import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/tickets_cubit.dart';
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ Лисичка успешно прочитала .env");
  } catch (e) {
    print("❌ Ошибка загрузки .env: $e");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const YakutskHubApp());
}

class YakutskHubApp extends StatelessWidget {
  const YakutskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketsCubit()..loadTickets()..loadSubsidies(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Якутск•HUB',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
