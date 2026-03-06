import 'package:flutter/material.dart';

class SmartFoxAssistant extends StatefulWidget {
  const SmartFoxAssistant({super.key});

  @override
  State<SmartFoxAssistant> createState() => _SmartFoxAssistantState();
}

class _SmartFoxAssistantState extends State<SmartFoxAssistant> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Анимация "дыхания"
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _showFoxMessage() {
    final phrases = [
      "Очки протер, данные проверил — в Якутске всё стабильно! 🤓",
      "На улице мороз, не забудь варежки! ❄️",
      "Курс валют сегодня интересный, слежу внимательно! 💸",
      "По моим расчетам, пора пить горячий чай! ☕",
      "В Хатассах всё спокойно, я всё вижу! 🚢",
      "Доченька молодец, что попросила очки для меня! Теперь я вижу всё! 🦊👓"
    ];

    final randomPhrase = (phrases..shuffle()).first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C2128),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text("🦊", style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Text("УМНЫЙ ЛИС", style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(randomPhrase, style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Понял, спасибо!", style: TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton(
        onPressed: _showFoxMessage,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orangeAccent, width: 2),
            boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 15)],
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF1C2128),
            radius: 28,
            child: ClipOval(
              child: Image.asset(
                "assets/images/fox.png", // Твоя картинка в очках
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                // Если картинка вдруг не подгрузится, покажем эмодзи в очках
                errorBuilder: (context, error, stackTrace) =>
                const Text("🤓", style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
