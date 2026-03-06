import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FerryWebView extends StatefulWidget {
  const FerryWebView({super.key});

  @override
  State<FerryWebView> createState() => _FerryWebViewState();
}

class _FerryWebViewState extends State<FerryWebView> {
  late final WebViewController controller;
  bool isLoading = true; // Следим за загрузкой

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0D1117))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://paromonline.sakha.gov.ru'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('КАМЕРЫ ОНЛАЙН',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
        backgroundColor: const Color(0xFF1C2128),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // САМ САЙТ
          WebViewWidget(controller: controller),

          // КРУТИЛКА (пока грузится)
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF007AFF),
              ),
            ),
        ],
      ),
    );
  }
}
