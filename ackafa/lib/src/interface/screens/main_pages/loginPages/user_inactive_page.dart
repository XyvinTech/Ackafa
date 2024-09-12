import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserInactivePage extends ConsumerWidget {
  const UserInactivePage({super.key});

  Future<void> _refreshUser(WidgetRef ref, BuildContext context) async {
    final user = await ref.read(userProvider.notifier).refreshUser();
    if (user?.status == 'awaiting_payment') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaymentConfirmationPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.red,
        onRefresh: () async => _refreshUser(ref, context),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.hexagonDots(
                    color: const Color(0xFFE30613),
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your request to join has been sent',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Access to the app will be made',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const Text(
                    'available to you soon',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const Text(
                    'Thank you for your patience',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
