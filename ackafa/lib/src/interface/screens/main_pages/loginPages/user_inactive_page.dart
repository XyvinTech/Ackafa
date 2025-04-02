import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserInactivePage extends ConsumerWidget {
  const UserInactivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.red,
        onRefresh: () async {
          final user = await ref.read(userProvider.notifier).refreshUser();
          if (user?.status == 'awaiting_payment') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentConfirmationPage()),
            );
          }
        },
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/approval_waiting.png'),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Your membership is under approval',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Kindly contact your college alumni officials for approval',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
