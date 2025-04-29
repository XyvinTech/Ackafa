import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInactivePage extends ConsumerWidget {
  const UserInactivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
               LoggedIn = false;
                        final SharedPreferences preferences =
                            await SharedPreferences.getInstance();

                        preferences.setString('token', '');
                        preferences.setString('id', '');

                        // Clear the entire stack and push the login screen
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login_screen',
                          (Route<dynamic> route) =>
                              false, // This removes all the previous routes
                        );
              Navigator.popUntil(context, (route) => route.isFirst); // Go back to first page (login)
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.red,
        onRefresh: () async {
          final refreshedUser = await ref.read(userProvider.notifier).refreshUser();
          if (refreshedUser?.status == 'awaiting_payment') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentConfirmationPage(),
              ),
            );
          }
        },
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/approval_waiting.png'),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      user?.status == 'rejected'
                          ? 'Your membership request has been rejected'
                          : 'Your membership is under approval',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: user?.status == 'rejected' ? Colors.red : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (user?.status != 'rejected') // Show only for non-rejected
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
