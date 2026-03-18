import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yakutsk_hub/screens/pharmacy_screen.dart';
import '../services/api_service.dart';
import '../models/yakutsk_data.dart';
import '../utils/app_utils.dart';
import '../widgets/price_chart.dart';
import 'ferry_view_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final ApiService apiService = ApiService();
  late Future<YakutskData?> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = apiService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text("🏙️ YKT LIVE",
            style: GoogleFonts.inter(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 22)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<YakutskData?>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("❌ Ошибка связи с сервером", style: TextStyle(color: Colors.white54)));
          }
          final data = snapshot.data!;
          DateTime yktNow = AppUtils.getYakutskTime();
          int yktHour = yktNow.hour;
          int yktMonth = yktNow.month;
          String heroStatus;
          if (data.holiday.isNotEmpty) {
            heroStatus = "ОТДЫХАЕМ! 🌸\n${data.holiday}";
          } else if (yktHour >= 16 || yktHour < 6) {
            if (yktMonth >= 3 && yktMonth <= 5) {
              heroStatus = "ВЕСЕННИЙ ВЕЧЕР 🌷\nСВЕТЛЕЕТ С КАЖДЫМ ДНЕМ";
            } else if (yktMonth == 11 || yktMonth <= 2) {
              heroStatus = "ЗАНЯТИЯ ОКОНЧЕНЫ 🌙\nДОБРОЙ НОЧИ";
            } else {
              heroStatus = "ОСЕННИЙ ВЕЧЕР 🍂\nОТДЫХАЙТЕ";
            }
          } else {
            if (data.weatherAlert.contains("АКТИРОВКА")) {
              heroStatus = "🚨 ВНИМАНИЕ:\nАКТИРОВКА";
            } else if (yktMonth >= 3 && yktMonth <= 5) {
              heroStatus = "ВЕСНА В ГОРОДЕ ☀️\nХОЛОДА ОТСТУПАЮТ";
            } else {
              heroStatus = "✅ ЗАНЯТИЯ ИДУТ";
            }
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() { dataFuture = apiService.fetchData(); });
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeroLiveCard(data, heroStatus),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    flex: 3,
                    child: _buildDetailTile(
                      "🚢 ПАРОМЫ / ПРИЧАЛ",
                      data.ferryStatus,
                      Icons.directions_boat,
                      Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 2,
                    child: _buildMiniPhoto('assets/images/yakutsk_city2.jpg'),
                  ),
                ]),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: const BorderSide(color: Color(0xFF007AFF), width: 0.5),
                  ),
                  icon: const Icon(Icons.videocam, color: Color(0xFF007AFF)),
                  label: const Text(
                    "СМОТРЕТЬ КАМЕРЫ ОНЛАЙН",
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const FerryWebView()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C2128),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    side: const BorderSide(color: Color(0xFF34C759), width: 0.5),
                  ),
                  icon: const Icon(Icons.phone_in_talk, color: Color(0xFF34C759)),
                  label: const Text("ГОРЯЧАЯ ЛИНИЯ ПЕРЕПРАВЫ",
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  onPressed: () async {
                    final Uri url = Uri.parse('tel:+74112449112');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
                const SizedBox(height: 20),
                ...data.winterRoads.map((road) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildDetailTile(
                    road['route'] ?? "Зимник",
                    "${road['status']} • ${road['weightLimit']}Т",
                    Icons.ac_unit,
                    const Color(0xFF007AFF),
                  ),
                )).toList(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    side: const BorderSide(color: Colors.redAccent, width: 0.8),
                  ),
                  icon: const Icon(Icons.medical_services_outlined, color: Colors.redAccent, size: 28),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("АПТЕЧНЫЙ НАВИГАТОР",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                      Text("AI-ПОИСК И СКАНЕР ЛЕКАРСТВ",
                          style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PharmacyScreen()),
                    );
                  },
                ),
                const SizedBox(height: 30),
                const Text("🛫 АВИАБИЛЕТЫ & ТРЕНДЫ",
                    style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(height: 15),
                const PriceChart(),
                const SizedBox(height: 20),
                const Text("🔥 ГОРЯЩИЕ ПРЕДЛОЖЕНИЯ",
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 10),
                ...data.flights.take(4).map((flight) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.airplane_ticket_outlined, color: Colors.blueAccent, size: 24),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(flight['destination'] ?? "Направление",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(flight['date'] ?? "Дата уточняется",
                                style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${flight['price'].round()} ₽",
                              style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w900, fontSize: 18)),
                          const Text("SALE", style: TextStyle(color: Colors.orangeAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildHeroLiveCard(YakutskData data, String status) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(image: AssetImage('assets/images/yakutsk_city.jpg'), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.85), Colors.transparent])),
        padding: const EdgeInsets.all(25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
          const Text("🏙️ YKT LIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26)),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              status,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.orange.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
  Widget _buildMiniPhoto(String path) {
    return Container(height: 85, decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover)));
  }
  Widget _buildDetailTile(String title, String value, IconData icon, Color color) {
    String updateTime = AppUtils.formatTime(AppUtils.getYakutskTime());
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        title.toUpperCase(),
                        style: TextStyle(color: color.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2)
                    ),
                    const SizedBox(height: 2),
                    Text(
                        value,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)
                    ),
                  ]
              )
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("LIVE", style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(updateTime, style: const TextStyle(color: Colors.white24, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
