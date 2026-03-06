import 'package:flutter/material.dart';

class HubWidgets {
  // Вспомогательный метод для "яблочной" подложки иконки
  static Widget _buildIconBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // Мягкий блик
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 26, color: Colors.white),
    );
  }

  // Карточка валюты (маленький элемент)
  static Widget currItem(String code, String val) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(code, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
    ],
  );

  // Широкая карточка (Валюты)
  static Widget buildWideCard(String title, String v1, String v2, String v3, IconData icon, Color color) => Container(
    width: double.infinity, height: 125,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(color: color.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white70, letterSpacing: 1.2)),
      const Spacer(),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        currItem('USD', v1),
        currItem('EUR', v2),
        currItem('CNY', v3),
        _buildIconBadge(icon, color),
      ]),
    ]),
  );

  // Большая карточка (Авиа, Афиша)
  static Widget buildBigCard(String title, String subtitle, IconData icon, Color color, VoidCallback? onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 110,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8) // Тень падает вниз
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(children: [
        _buildIconBadge(icon, color),
        const SizedBox(width: 20),
        Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
          Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
        ]
        ),
        const Spacer(),
        Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.4), size: 14),
      ]),
    ),
  );

  // Маленькая карточка (Новости)
  static Widget buildSmallCard(String title, String value, IconData icon, Color color, VoidCallback? onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 130, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))
      ],
    ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(icon, size: 24, color: Colors.white),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white70,letterSpacing: 1)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
      ]),
    ),
  );
}
