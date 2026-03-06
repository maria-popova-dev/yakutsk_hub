import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/bank_rate_model.dart'; // Твоя вынесенная модель

class BanksPage extends StatelessWidget {
  const BanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ДАННЫЕ (Имитация данных из банков Якутска)
    final List<BankRate> banks = [
      BankRate(name: 'АЛМАЗЭРГИЭНБАНК', usd: 92.8, eur: 98.4, cny: 12.8),
      BankRate(name: 'СОЛИД БАНК', usd: 92.9, eur: 98.5, cny: 12.9),
      BankRate(name: 'ГАЗПРОМБАНК', usd: 93.2, eur: 98.8, cny: 13.1),
      BankRate(name: 'ВТБ', usd: 93.5, eur: 99.1, cny: 13.3),
      BankRate(name: 'СОВКОМБАНК', usd: 93.8, eur: 99.4, cny: 13.4),
      BankRate(name: 'АТБ', usd: 93.9, eur: 99.6, cny: 13.5),
      BankRate(name: 'СБЕРБАНК', usd: 94.5, eur: 101.2, cny: 13.8),
    ];

    // 2. АЛГОРИТМ: Сортируем список (самый дешевый USD — вверху)
    banks.sort((a, b) => a.usd.compareTo(b.usd));

    // Находим минимальный курс для визуального выделения (isBest)
    final double bestUsd = banks.first.usd;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: Text(
          'ЛУЧШИЕ КУРСЫ • ЯКУТСК',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'КУРСЫ ПРОДАЖИ В КАССАХ ГОРОДА',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5
            ),
          ),
          const SizedBox(height: 20),

          // Используем ListView.builder для эффективного отображения списка
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bank = banks[index];
                final bool isBest = bank.usd == bestUsd;

                return _bankCard(
                    bank.name,
                    '${bank.usd} ₽',
                    '${bank.eur} ₽',
                    '${bank.cny} ₽',
                    isBest
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Opacity(
              opacity: 0.4,
              child: Text(
                'Данные актуальны на сегодня\nИсточник: Мониторинг банков Якутска',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Виджет одной карточки банка
  Widget _bankCard(String name, String usd, String eur, String cny, bool isBest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(24),
        // Подсвечиваем лучший курс фиолетовой рамкой
        border: isBest ? Border.all(color: const Color(0xFF5856D6), width: 2) : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (isBest)
                const Icon(Icons.auto_awesome, color: Color(0xFF5856D6), size: 18),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currencySmall('USD', usd, isBest),
              _currencySmall('EUR', eur, false),
              _currencySmall('CNY', cny, false),
            ],
          ),
        ],
      ),
    );
  }

  // Маленький блок валюты внутри карточки
  Widget _currencySmall(String label, String value, bool highlight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
            value,
            style: TextStyle(
                color: highlight ? const Color(0xFF5856D6) : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900
            )
        ),
      ],
    );
  }
}
