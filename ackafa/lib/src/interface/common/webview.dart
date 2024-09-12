import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends ConsumerStatefulWidget {
  final String paymentUrl;

  const PaymentWebView({
    Key? key,
    required this.paymentUrl,
  }) : super(key: key);

  @override
  ConsumerState<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends ConsumerState<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.paymentUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            // Check if the current URL starts with the success URL
            if (url.startsWith(
                'https://akcafconnect.com/api/v1/payment/success?session_id')) {
              // Delay the pop action by 2 seconds
              await Future.delayed(const Duration(seconds: 3));

              // Ensure the widget is still mounted before calling pop
              if (mounted) {
                Navigator.pop(context);
                ref.invalidate(userProvider);
              }
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
