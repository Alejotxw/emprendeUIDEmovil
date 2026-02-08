import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BotpressChatbot extends StatefulWidget {
  const BotpressChatbot({super.key});

  @override
  State<BotpressChatbot> createState() => _BotpressChatbotState();
}

class _BotpressChatbotState extends State<BotpressChatbot> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // Inyectamos CSS que oculta los marcos externos pero NO toca el chat
            _controller.runJavaScript('''
              (function() {
                const style = document.createElement('style');
                style.innerHTML = `
                  /* 1. Ocultamos el header externo (donde dice Your Brand Assistant) */
                  header, 
                  [class*="header"], 
                  [class*="Header"] { 
                    display: none !important; 
                  }

                  /* 2. Ocultamos el botón de Share y el footer */
                  footer,
                  [class*="share"],
                  [class*="Share"],
                  .bp-share-container {
                    display: none !important;
                  }

                  /* 3. Forzamos al contenedor del CHAT a ser visible y ocupar todo */
                  /* Botpress suele usar un ID o clase específica para el widget real */
                  #bp-web-widget-container, 
                  .bp-widget-container,
                  main {
                    display: block !important;
                    visibility: visible !important;
                    height: 100vh !important;
                    width: 100vw !important;
                    margin: 0 !important;
                    padding: 0 !important;
                    position: fixed !important;
                    top: 0 !important;
                    left: 0 !important;
                  }

                  /* 4. Eliminamos el logo de 'Powered by' si aparece fuera del chat */
                  .bp-powered-by {
                    display: none !important;
                  }
                `;
                document.head.appendChild(style);
              })();
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "https://cdn.botpress.cloud/webchat/v3.5/shareable.html?configUrl=https://files.bpcontent.cloud/2025/08/12/13/20250812133500-YA9U0TP5.json"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Taek'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}