import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/yakutsk_data.dart';

class SummaryScreen extends StatefulWidget {
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
      backgroundColor: const Color(0xFF0F172A), // Твой фирменный темный фон
      appBar: AppBar(
        title: const Text("ОПЕРАТИВНЫЙ ШТАБ", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
            return const Center(child: Text("❌ Ошибка связи с Java", style: TextStyle(color: Colors.white54)));
          }

          final data = snapshot.data!;
          bool isAktirovka = data.weatherAlert.contains("АКТИРОВКА");

          return RefreshIndicator(
            onRefresh: () async {
              setState(() { dataFuture = apiService.fetchData(); });
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. Главный баннер (Актировка или Погода)
                _buildHeaderCard(
                  isAktirovka ? "ВНИМАНИЕ: АКТИРОВКА" : "ЗАНЯТИЯ ИДУТ",
                  data.weatherAlert,
                  isAktirovka ? Colors.redAccent : Colors.blueAccent,
                  isAktirovka ? Icons.warning_amber_rounded : Icons.school,
                ),
                const SizedBox(height: 20),

                // 2. Детали (Паромы)
                _buildDetailTile(
                    "🚢 ПРИЧАЛ / ПАРОМЫ",
                    data.ferryStatus,
                    Icons.directions_boat,
                    Colors.orangeAccent),

                const SizedBox(height: 10),
                ...data.winterRoads.map((road) => _buildDetailTile(
                    road['route'] ?? "Зимник",
                    "${road['status']} • ДО ${road['weightLimit']} ТОНН",
                    Icons.ac_unit,
                    const Color(0xFF007AFF) // Красивый морозный синий
                )).toList(),
                const SizedBox(height: 30),
                const Text("🛫 АВИАБИЛЕТЫ (SALE)",
                    style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(height: 15),

                // 3. Список билетов из Java
                ...data.flights.map((f) => _buildFlightCard(f)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(String title, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(dynamic f) {
    bool isCheap = f['price'] < 30000;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isCheap ? Colors.green.withOpacity(0.3) : Colors.white10),
      ),
      child: Row(
        children: [
          Icon(Icons.flight_takeoff, color: isCheap ? Colors.green : Colors.white54),
          const SizedBox(width: 15),
          Expanded(child: Text("${f['destination']}", style: const TextStyle(color: Colors.white, fontSize: 15))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${f['price']} ₽", style: TextStyle(color: isCheap ? Colors.green : Colors.white, fontWeight: FontWeight.bold)),
              Text("${f['date']}", style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

