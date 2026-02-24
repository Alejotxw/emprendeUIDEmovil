import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BotpressAsistente extends StatefulWidget {
  @override
  State<BotpressAsistente> createState() => _BotpressAsistenteState();
}

class _BotpressAsistenteState extends State<BotpressAsistente> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://cdn.botpress.cloud/webchat/v3.6/shareable.html?configUrl=https://files.bpcontent.cloud/2026/02/07/15/20260207152304-PWUCQU6K.json'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente Virtual')),
      body: WebViewWidget(controller: controller),
    );
  }
}