import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Если будешь добавлять кнопки-ссылки
import 'ferry_view_screen.dart';

class FerryPage extends StatelessWidget {
  const FerryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Определяем сезон по якутскому времени
    DateTime yakutskTime = DateTime.now().toUtc().add(const Duration(hours: 9));
    int month = yakutskTime.month;

    // Навигация открыта с мая по октябрь
    bool isNavigationSeason = month >= 5 && month <= 10;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('ПЕРЕПРАВА • ЯКУТСК', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildStatusBanner(isNavigationSeason),
          const SizedBox(height: 30),
          Text(
              isNavigationSeason ? 'РАСПИСАНИЕ ПАРОМОВ' : 'ЛЕДОВАЯ ПЕРЕПРАВА (ЗИМНИК)',
              style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5)
          ),
          const SizedBox(height: 15),

          if (isNavigationSeason) ...[
            _ferryCard('ЯКУТСК — Н. БЕСТЯХ', '08:00 — 22:00 (каждые 30 мин)', Icons.directions_boat, const Color(0xFFFF9500)),
            _ferryCard('КАНГАЛАССЫ — СОТТИНЦЫ', 'По заполнению', Icons.sailing, const Color(0xFF5856D6)),
          ] else ...[
            _ferryCard('ХАТАССЫ — ПАВЛОВСК', 'ОТКРЫТО • ДО 40 ТОНН', Icons.ac_unit, const Color(0xFF007AFF)),
            _ferryCard('КАНГАЛАССЫ — СОТТИНЦЫ', 'ОТКРЫТО • ДО 30 ТОНН', Icons.ice_skating, const Color(0xFF34C759)),
            const SizedBox(height: 20),
            _buildWarningCard("Внимание! Выезд на лед вне ледовых переправ строго запрещен и опасен для жизни."),
            const SizedBox(height: 20),

            // КНОПКА 1
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2128),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: const BorderSide(color: Color(0xFF007AFF), width: 0.5),
              ),
              icon: const Icon(Icons.videocam, color: Color(0xFF007AFF)),
              label: const Text("КАМЕРЫ ОНЛАЙН", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                print("НАЖАТЫ КАМЕРЫ");
                Navigator.push(context, MaterialPageRoute(builder: (c) => const FerryWebView()));
              },
            ),

            const SizedBox(height: 12),

            // КНОПКА 2
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2128),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: const BorderSide(color: Color(0xFF34C759), width: 0.5),
              ),
              icon: const Icon(Icons.phone_in_talk, color: Color(0xFF34C759)),
              label: const Text("ПОЗВОНИТЬ ДИСПЕТЧЕРУ", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                print("НАЖАТ ЗВОНОК");
                launchUrl(Uri.parse('tel:+74112431115'));
              },
            ),
          ], // Конец else
        ], // Конец ListView children
      ),
    );
  }

  Widget _buildStatusBanner(bool isOpen) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isOpen ? const Color(0xFF34C759) : const Color(0xFF007AFF)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isOpen ? const Color(0xFF34C759) : const Color(0xFF007AFF), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(isOpen ? Icons.waves : Icons.snowboarding, color: isOpen ? const Color(0xFF34C759) : const Color(0xFF007AFF), size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              isOpen ? 'РЕЧНАЯ НАВИГАЦИЯ ОТКРЫТА' : 'ЛЕДОВАЯ ПЕРЕПРАВА ДЕЙСТВУЕТ',
              style: TextStyle(color: isOpen ? const Color(0xFF34C759) : const Color(0xFF007AFF), fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ferryCard(String route, String info, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1C2128), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(route, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(info, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
      child: Text(text, style: const TextStyle(color: Colors.redAccent, fontSize: 11, height: 1.4), textAlign: TextAlign.center),
    );
  }
}
