import 'package:flutter/material.dart';

class AppUtils {
  // Точное время Якутска
  static DateTime getYakutskTime() => DateTime.now().toUtc().add(const Duration(hours: 9));

  // Форматирование времени HH:mm
  static String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  // Логика текстов пробок
  static String getTrafficText(int level) {
    if (level <= 2) return "Движение свободное";
    if (level <= 4) return "Небольшие затруднения";
    if (level <= 6) return "Затруднено";
    if (level <= 8) return "Серьёзные пробки";
    return "Город стоит";
  }

  // Логика цветов пробок
  static Color getTrafficColor(int level) {
    if (level <= 2) return const Color(0xFF34C759);
    if (level <= 4) return const Color(0xFF8BC34A);
    if (level <= 6) return const Color(0xFFFFCC00);
    if (level <= 8) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  // Склонение слова "балл"
  static String getTrafficSuffix(int level) {
    if (level == 1) return "балл";
    if (level >= 2 && level <= 4) return "балла";
    return "баллов";
  }
}
