import 'dart:math';
import 'package:flutter/material.dart';

class SnowBackground extends StatefulWidget {
  const SnowBackground({super.key});

  @override
  State<SnowBackground> createState() => _SnowBackgroundState();
}

class _SnowBackgroundState extends State<SnowBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<Snowflake> farSnow = [];
  final List<Snowflake> midSnow = [];
  final List<Snowflake> nearSnow = [];

  final List<Star> stars = [];

  final random = Random();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..addListener(() {
      updateSnow();
    });

    generateSnow();
    generateStars();

    controller.repeat();
  }

  void generateSnow() {
    for (int i = 0; i < 60; i++) {
      farSnow.add(Snowflake(random));
    }

    for (int i = 0; i < 40; i++) {
      midSnow.add(Snowflake(random));
    }

    for (int i = 0; i < 25; i++) {
      nearSnow.add(Snowflake(random));
    }
  }

  void generateStars() {
    for (int i = 0; i < 120; i++) {
      stars.add(Star(random));
    }
  }

  void updateSnow() {
    setState(() {
      for (var snow in farSnow) {
        snow.fall(0.3);
      }

      for (var snow in midSnow) {
        snow.fall(0.6);
      }

      for (var snow in nearSnow) {
        snow.fall(1.0);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnowPainter(
        farSnow,
        midSnow,
        nearSnow,
        stars,
      ),
      size: Size.infinite,
    );
  }
}

class Snowflake {
  double x;
  double y;
  double size;
  double speed;

  Snowflake(Random random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        size = random.nextDouble() * 3 + 1,
        speed = random.nextDouble() * 0.003 + 0.001;

  void fall(double multiplier) {
    y += speed * multiplier;

    if (y > 1) {
      y = 0;
    }
  }
}

class Star {
  double x;
  double y;
  double size;

  Star(Random random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        size = random.nextDouble() * 2 + 0.5;
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> farSnow;
  final List<Snowflake> midSnow;
  final List<Snowflake> nearSnow;
  final List<Star> stars;

  SnowPainter(
      this.farSnow,
      this.midSnow,
      this.nearSnow,
      this.stars,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white;

    for (var star in stars) {
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        starPaint,
      );
    }

    drawSnow(canvas, size, farSnow, 0.5);
    drawSnow(canvas, size, midSnow, 0.8);
    drawSnow(canvas, size, nearSnow, 1.2);
  }

  void drawSnow(
      Canvas canvas, Size size, List<Snowflake> snowflakes, double opacity) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity);

    for (var snow in snowflakes) {
      canvas.drawCircle(
        Offset(
          snow.x * size.width,
          snow.y * size.height,
        ),
        snow.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}