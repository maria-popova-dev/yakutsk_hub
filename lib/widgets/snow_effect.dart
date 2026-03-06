import 'dart:math';
import 'package:flutter/material.dart';

class SnowEffect extends StatefulWidget {
  const SnowEffect({super.key});

  @override
  State<SnowEffect> createState() => _SnowEffectState();
}

class _SnowEffectState extends State<SnowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final List<Snowflake> snowflakes = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    for (int i = 0; i < 120; i++) {
      snowflakes.add(Snowflake());
    }

    controller.addListener(() {
      setState(() {
        for (var flake in snowflakes) {
          flake.fall();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnowPainter(snowflakes),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Snowflake {
  static final Random random = Random();

  double x = random.nextDouble();
  double y = random.nextDouble();
  double radius = random.nextDouble() * 2 + 1;
  double speed = random.nextDouble() * 0.002 + 0.001;
  double wind = random.nextDouble() * 0.002 - 0.001;

  void fall() {
    y += speed;
    x += wind;

    if (y > 1) {
      y = 0;
      x = random.nextDouble();
    }

    if (x > 1) x = 0;
    if (x < 0) x = 1;
  }
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  SnowPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var flake in snowflakes) {
      canvas.drawCircle(
        Offset(flake.x * size.width, flake.y * size.height),
        flake.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}