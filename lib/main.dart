import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Добавили библиотеку
import 'cubits/tickets_cubit.dart'; // Подключили логику
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Добавь этот импорт
import 'firebase_options.dart'; // Тот самый новый файл

void main() async{
  // 1. Обязательная строка для работы с плагинами
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Инициализируем Firebase именно с твоими настройками
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const YakutskHubApp());
}

class YakutskHubApp extends StatelessWidget {
  const YakutskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Оборачиваем всё в BlocProvider, чтобы логика билетов
    // была доступна внутри MainScreen, но не влияла на визуализацию
    return BlocProvider(
      create: (context) => TicketsCubit()..loadTickets()..loadSubsidies(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Якутск•HUB',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          // Твой шрифт остается нетронутым
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
          // Больше никаких автоматических смен цветов!
          // Дизайн остается таким, каким ты его сделала.
        ),
        home: const MainScreen(),
      ),
    );
  }
}
