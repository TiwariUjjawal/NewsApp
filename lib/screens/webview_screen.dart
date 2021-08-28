import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  String url;
  WebViewScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: url,
        ),
      ),
    );
  }
}