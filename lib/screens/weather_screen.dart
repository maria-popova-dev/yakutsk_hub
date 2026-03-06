import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../widgets/snow_effect.dart';
import '../widgets/aurora_background.dart';

class WeatherPage extends StatelessWidget {
  final String temp;
  final String feelsLike;
  final bool isAktirovka;

  const WeatherPage({
    super.key,
    required this.temp,
    required this.feelsLike,
    required this.isAktirovka,
  });

  @override
  Widget build(BuildContext context) {
    HapticFeedback.lightImpact();

    final yakutskTime = DateTime.now().add(const Duration(hours: 6));
    final bool isNight = yakutskTime.hour >= 19 || yakutskTime.hour <= 8;
    final int currentTemp =
        int.tryParse(temp.replaceAll(RegExp(r'[^0-9-]'), '')) ?? -20;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [

          /// 🌌 ФОН
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isNight
                    ? [const Color(0xFF020A12), const Color(0xFF102A43)]
                    : [const Color(0xFF4A90E2), const Color(0xFF91BEF4)],
              ),
            ),
          ),

          /// 🌌 СЕВЕРНОЕ СИЯНИЕ
          if (isNight)
            const Positioned.fill(
              child: AuroraBackground(),
            ),

          /// ☁️ ОБЛАКА
          Positioned(
            top: 150,
            right: -100,
            child: _blurCircle(400, Colors.blue.withOpacity(0.2)),
          ),

          Positioned(
            top: 300,
            left: -50,
            child: _blurCircle(300, Colors.black.withOpacity(0.3)),
          ),

          /// 🌫 BLUR
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),

          /// ⭐ ЗВЕЗДЫ
          if (isNight)
            ...List.generate(
              40,
                  (index) => _BlinkingStar(index: index),
            ),

          /// ❄️ СНЕГ (3D)
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.8,
                child: SnowEffect(),
              ),
            ),
          ),

          /// 📱 UI
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isAktirovka) _buildAktirovkaBanner(),
                  const SizedBox(height: 30),

                  Text(
                    'ЯКУТСК',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),

                  Text(
                    temp,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 90,
                      fontWeight: FontWeight.w100,
                    ),
                  ),

                  Text(
                    currentTemp < -35 ? 'Ледяной туман' : 'Ясно',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Ощущается как $feelsLike',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildDetailGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildAktirovkaBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning, color: Colors.white),
          SizedBox(width: 15),
          Text(
            "АКТИРОВКА: ШКОЛЫ ЗАКРЫТЫ",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildDetailGrid() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.water_drop, color: Colors.white54, size: 20),
              SizedBox(height: 5),
              Text("Влажность",
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text("78%",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.air, color: Colors.white54, size: 20),
              SizedBox(height: 5),
              Text("Ветер",
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text("3 м/с",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

/// ⭐ МЕРЦАЮЩИЕ ЗВЕЗДЫ
class _BlinkingStar extends StatefulWidget {
  final int index;

  const _BlinkingStar({required this.index});

  @override
  State<_BlinkingStar> createState() => _BlinkingStarState();
}

class _BlinkingStarState extends State<_BlinkingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2 + (widget.index % 3)),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (widget.index * 37.0) % 700,
      left: (widget.index * 53.0) % 400,
      child: FadeTransition(
        opacity: _controller,
        child: Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
