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
      ..setBackgroundColor(Colors.transparent) // Para que no tape tu app
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body { background: transparent; margin: 0; padding: 0; }
            </style>
          </head>
          <body>
            <script src="https://cdn.botpress.cloud/webchat/v3.5/inject.js" defer></script>
            <script src="https://files.bpcontent.cloud/2026/02/07/15/20260207152304-5QHP5JRR.js" defer></script>
          </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    // Usamos un SizedBox pequeño porque la burbuja de Botpress 
    // se dibuja sola fuera del contenedor gracias al script
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: WebViewWidget(controller: _controller),
    );
  }
}