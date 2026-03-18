import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FerryWebView extends StatefulWidget {
  const FerryWebView({super.key});

  @override
  State<FerryWebView> createState() => _FerryWebViewState();
}

class _FerryWebViewState extends State<FerryWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0D1117))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => isLoading = true),
          onPageFinished: (url) {
            setState(() => isLoading = false);
            controller.runJavaScript("""
              var sel = ['header', '.footer', '.sidebar', '.ad-block', '#cookie-notice', '.top-nav'];
              sel.forEach(s => {
                var el = document.querySelector(s);
                if(el) el.style.display = 'none';
              });
              document.body.style.padding = '0';
              document.body.style.margin = '0';
            """);
          },
          onWebResourceError: (error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⚠️ Ошибка загрузки камеры. Проверьте сеть.')),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://worldcams.ru'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('ЯКУТСК • LIVE • КАМЕРЫ',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        backgroundColor: const Color(0xFF1C2128),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF007AFF)),
            ),
        ],
      ),
    );
  }
}
