import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:yakutsk_hub/screens/weather_screen.dart';
import '../utils/app_utils.dart';
import '../widgets/hub_widgets.dart';
import '../widgets/smart_fox_assistant.dart';
import 'ferry_screen.dart';
import 'tickets_screen.dart';
import 'banks_screen.dart';
import 'summary_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  // ПЕРЕМЕННЫЕ
  String temperature = "−19°C";
  String feelsLike = "−25°C";
  double windSpeed = 0.0;
  String usdRate = "— ₽";
  String eurRate = "— ₽";
  String cnyRate = "— ₽";
  String currentTime = "00:00";
  String currentDate = "";
  String exchangeDateInfo = "Загрузка...";
  late AnimationController _pulseController;

  Timer? _timer;
  Timer? _weatherTimer;
  Timer? _trafficTimer;

  IconData weatherIcon = Icons.ac_unit;
  List<Color> weatherColors = [const Color(0xFF1e3c72), const Color(0xFF2a5298)];

  int trafficLevel = 1;
  String trafficText = "Дороги свободны";
  String trafficUpdated = "обновляется";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _updateTime();
    _loadInitialData();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
    _trafficTimer = Timer.periodic(const Duration(minutes: 5), (timer) => fetchRealTraffic());
    _weatherTimer = Timer.periodic(const Duration(minutes: 15), (timer) => _loadInitialData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _weatherTimer?.cancel();
    _trafficTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // ЛОГИКА (ВРЕМЯ, ДАННЫЕ, API)
  void _updateTime() {
    final now = AppUtils.getYakutskTime();
    setState(() {
      currentTime = AppUtils.formatTime(now);
      currentDate = "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";
    });
  }

  void _loadInitialData() {
    fetchWeather();
    Future.delayed(const Duration(milliseconds: 300), () {
      fetchExchangeRate();
      fetchRealTraffic();
    });
  }

  Future<void> fetchRealTraffic() async {
    final yakutskTime = AppUtils.getYakutskTime();
    int hour = yakutskTime.hour;
    int minute = yakutskTime.minute;
    int level;

    if (hour >= 23 || hour <= 6) { level = 1; }
    else if (hour == 8) { level = (minute < 45) ? 8 : 6; }
    else if (hour == 17 && minute >= 30 || hour == 18) { level = 9; }
    else { level = 3; }

    setState(() {
      trafficLevel = level;
      trafficText = AppUtils.getTrafficText(level);
      trafficUpdated = AppUtils.formatTime(yakutskTime);
    });
  }

  Future<void> fetchExchangeRate() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.cbr-xml-daily.ru'),
        headers: {"Accept": "application/json"},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final valute = data['Valute'];
        setState(() {
          usdRate = "${(valute['USD']['Value'] as num).toStringAsFixed(1)} ₽";
          eurRate = "${(valute['EUR']['Value'] as num).toStringAsFixed(1)} ₽";
          cnyRate = "${(valute['CNY']['Value'] as num).toStringAsFixed(1)} ₽";
          String rawDate = data['Date'];
          exchangeDateInfo = "ЦБ РФ: ${rawDate.substring(8, 10)}.${rawDate.substring(5, 7)}";
        });
      }
    } catch (e) {
      _setFallbackRates();
    }
  }

  void _setFallbackRates() {
    setState(() {
      usdRate = "77.3 ₽"; eurRate = "91.3 ₽"; cnyRate = "11.2 ₽";
      exchangeDateInfo = "Курс ЦБ (Резерв)";
    });
  }

  Future<void> fetchWeather() async {
    try {
      final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': '62.0397', 'longitude': '129.7422',
        'current': 'temperature_2m,wind_speed_10m',
        'hourly': 'apparent_temperature', 'timezone': 'Asia/Yakutsk',
      });
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          num temp = data['current']['temperature_2m'];
          temperature = "${temp.round()}°C";
          windSpeed = (data['current']['wind_speed_10m'] as num).toDouble();
          int hour = DateTime.now().hour;
          num feels = data['hourly']['apparent_temperature'][hour];
          feelsLike = "${feels.round()}°C";
        });
      }
    } catch (e) { print(e); }
  }

  String _getActivatedStatus() {
    int hour = AppUtils.getYakutskTime().hour;
    if (hour >= 16 || hour < 6) return "ЗАНЯТИЯ ОКОНЧЕНЫ";
    double t = double.tryParse(temperature.replaceAll('°C', '').replaceAll('−', '-')) ?? 0;
    double w = windSpeed;
    double absT = t.abs();
    if (absT >= 50 || (absT >= 48 && w >= 2) || (absT >= 45 && w >= 3)) return "АКТИРОВКА: 1-11 КЛАССЫ";
    if (absT >= 48 || (absT >= 45 && w >= 2) || (absT >= 44 && w >= 3)) return "АКТИРОВКА: 1-8 КЛАССЫ";
    if (absT >= 45 || (absT >= 44 && w >= 2) || (absT >= 43 && w >= 3)) return "АКТИРОВКА: 1-5 КЛАССЫ";
    return "ЗАНЯТИЯ ИДУТ";
  }

  // BUILD И КАРТОЧКИ
  @override
  Widget build(BuildContext context) {
    String status = _getActivatedStatus();
    bool isAktirovka = status.contains("АКТИРОВКА");
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Column(children: [
          const Text('ЯКУТСК • HUB', style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
          Text("$currentTime  •  $currentDate", style: const TextStyle(fontSize: 12, color: Colors.white54)),
        ]),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white54), onPressed: _loadInitialData)],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          HubWidgets.buildBigCard(
            'ОПЕРАТИВНЫЙ ШТАБ',
            'Сводка: Паромы • Погода • Билеты',
            Icons.location_city,
            const Color(0xFF5AC8FA), // Приятный голубой цвет для штаба
                () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SummaryScreen()) // Твой новый экран
            ),
          ),
          const SizedBox(height: 18),
          HubWidgets.buildBigCard('АВИАБИЛЕТЫ', 'Субсидированные рейсы', Icons.flight_takeoff, const Color(0xFF34C759),
                  () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TicketsPage()))),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _buildWeatherCard(status, isAktirovka)),
            const SizedBox(width: 18),
            Expanded(child: HubWidgets.buildSmallCard('ПАРОМЫ', 'График', Icons.directions_boat, const Color(0xFFFF9500),
                    () => Navigator.push(context, MaterialPageRoute(builder: (c) => const FerryPage())))),
          ]),
          const SizedBox(height: 18),
        GestureDetector(
            onTap: () {
              // Команда для открытия нового экрана
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BanksPage()),
              );
            },
            child: HubWidgets.buildWideCard(
              'ОФИЦИАЛЬНЫЙ КУРС ЦБ РФ',
              usdRate,
              eurRate,
              cnyRate,
              Icons.account_balance,
              const Color(0xFF5856D6)
            ),),

          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _buildTrafficCard()),
            const SizedBox(width: 18),
            Expanded(child: HubWidgets.buildSmallCard('НОВОСТИ', 'SakhaDay', Icons.newspaper, const Color(0xFFFF2D55),
                    () => launchUrl(Uri.parse('https://sakhaday.ru')))),
          ]),
          const SizedBox(height: 18),
          HubWidgets.buildBigCard('АФИША ГОРОДА', 'Куда сходить сегодня?', Icons.confirmation_number_outlined, const Color(0xFFFF3B30),
                  () => launchUrl(Uri.parse('https://afisha.ykt.ru'))),
        ]),
      ),
      floatingActionButton: const SmartFoxAssistant(),
    );
  }

  Widget _buildWeatherCard(String status, bool isAktirovka) {
    return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          double pulse = isAktirovka ? _pulseController.value : 0.0;
          List<Color> colors = isAktirovka ? [const Color(0xFFFF416C), const Color(0xFFFF4B2B)] : weatherColors;
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherPage(
                        temp: temperature,
                        feelsLike: feelsLike,
                        isAktirovka: isAktirovka,
                    ),
                  ),
                );
              },
              child: Container(
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: colors.first.withOpacity(isAktirovka ? 0.4 + (pulse * 0.4) : 0.3), blurRadius: isAktirovka ? 10 + (pulse * 15) : 10)],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Icon(isAktirovka ? Icons.report_problem_rounded : weatherIcon, size: 28, color: Colors.white),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(temperature, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Ощущается: $feelsLike", style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: isAktirovka ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text(status, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isAktirovka ? Colors.red.shade900 : Colors.white)),
                ),
              ]),
            ]),
          )
          );
        }
    );
  }

  Widget _buildTrafficCard() {
    String suffix = AppUtils.getTrafficSuffix(trafficLevel);
    bool isHighTraffic = trafficLevel >= 7;
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse('https://yandex.ru')),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: 130,
        decoration: BoxDecoration(
          color: AppUtils.getTrafficColor(trafficLevel),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isHighTraffic ? [BoxShadow(color: AppUtils.getTrafficColor(trafficLevel).withOpacity(0.4), blurRadius: 10)] : [],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Icon(Icons.directions_car_filled, color: Colors.white),
              if (isHighTraffic) const Icon(Icons.warning_amber_rounded, color: Colors.white70, size: 16),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("ПРОБКИ", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white70)),
              Text("$trafficLevel $suffix", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(trafficText, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text("Якутск • $trafficUpdated", style: const TextStyle(fontSize: 8, color: Colors.white54)),
            ]),
          ],
        ),
      ),
    );
  }
}
