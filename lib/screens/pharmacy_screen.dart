import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../services/ocr_service.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final ImagePicker _picker = ImagePicker();
  final OCRService _ocrService = OCRService();
  String _recognizedText = "Нажмите на камеру, чтобы отсканировать упаковку";
  bool _isLoading = false;
  String _currentPharmacyAddress = "Якутск, Ленина 21";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkWeatherAdvice();
      }
    });
  }

  Future<void> _checkWeatherAdvice() async {
    final apiKey = dotenv.env['WEATHER_API'] ?? "";
    final baseUrl = dotenv.env['WEATHER_URL'] ?? "";
    if (apiKey.isEmpty || baseUrl.isEmpty) {
      return;
    }
    final url = "$baseUrl?q=Yakutsk&appid=$apiKey&units=metric&lang=ru";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int pressureHpa = data['main']['pressure'];
        double pressureMm = pressureHpa * 0.750062;
        double temp = data['main']['temp'].toDouble();
        String weatherAdvice = "В Якутске всё стабильно. Лисичка желает хорошего дня! 🦊";
        if (pressureMm < 745) {
          weatherAdvice =
          "Давление в Якутске падает (${pressureMm.toStringAsFixed(
              0)} мм)! 📉 Голова может болеть.";
        } else if (pressureMm > 755) {
          weatherAdvice = "Давление высокое (${pressureMm.toStringAsFixed(
              0)} мм)! 📈 Береги сосуды.";
        } else if (temp < -35) {
          weatherAdvice =
          "Ух, мороз $temp°C! ❄️ Береги лицо и руки, Лисичка волнуется.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            content: Text("🦊 Лисичка: $weatherAdvice",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      }
    } catch (e) {
      print("Ошибка погоды: $e");
    }
  }

  Future<void> _scanMedication() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return;
    setState(() => _isLoading = true);
    try {
      String text = await _ocrService.scanImage(photo.path);
      final response = await http.post(
        Uri.parse('http://192.168.31.194:8080/api/medicine/scan'),
        headers: {"Content-Type": "text/plain; charset=UTF-8"},
        body: text,
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes).trim();
        if (decodedBody.startsWith('{')) {
          final Map<String, dynamic> data = jsonDecode(decodedBody);
          setState(() {
            _recognizedText = "💊 Найдено: ${data['name'] ?? 'Не распознано'}\n"
                "💰 Цена: ${data['price'] ?? '—'}\n"
                "📍 Аптека: ${data['pharmacy'] ?? '—'}"
                "🦊 Аналог: ${data['analog'] ?? 'не найден'}";
          });
          if (data['name'] != "Лекарство не распознано" && data['name'] != null) {
            _showFoxAdvice(data['name'], data['price']);
          }
        } else {
          setState(() =>
          _recognizedText = "Лисичка запуталась: бэкенд прислал не текст, а что-то другое");
        }
      }
    } catch (e) {
      setState(() => _recognizedText = "Ошибка связи: $e");
      print("❌ Ошибка: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showFoxAdvice(String name, String price) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orangeAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Row(
          children: [
            const Text("🦊", style: TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Вижу $name! В Миницене на Ленина он по $price, а в Планете рядом — дороже. Сэкономим на вкусняшку?",
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap(String address) async {
    final String encodedAddress = Uri.encodeComponent("Якутск $address");
    final Uri url = Uri.parse("https://yandex.ru/maps/?text=$encodedAddress");
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("Ошибка открытия карт: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🦊 Лисичка не нашла карты на телефоне")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Аптечный навигатор",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                if (_isLoading)
                  const SizedBox(
                    height: 180,
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.orange)),
                  )
                else
                  Lottie.network(
                    'https://lottie.host',
                    height: 180,
                    repeat: true,
                    errorBuilder: (context, error, stackTrace) =>
                    const Text("🦊", style: TextStyle(fontSize: 80)),
                  ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade900
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text("РЕЗУЛЬТАТ СКАНЕРА",
                            style: TextStyle(color: Colors.white70,
                                fontSize: 12,
                                letterSpacing: 1.2)),
                        const SizedBox(height: 15),
                        Text(_recognizedText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        const Divider(color: Colors.white24, height: 30),
                        TextButton.icon(
                          onPressed: () {
                            _openMap(_currentPharmacyAddress);
                          },
                          icon: const Icon(Icons.location_on,
                              color: Colors.white),
                          label: const Text("НАЙТИ БЛИЖАЙШУЮ АПТЕКУ",
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: 220,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: _scanMedication,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("СКАНЕР", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

