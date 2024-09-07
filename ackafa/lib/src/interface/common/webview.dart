import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final String paymentUrl;

  const PaymentWebView({
    Key? key,
    required this.paymentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(paymentUrl));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
