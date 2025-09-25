import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/webview.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/profile_completetion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    log("Paymetn enabled?:$isPaymentEnabled");
    if (isPaymentEnabled) {
      log('Im in not logged in condition');
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Column(
                  children: [
                    Image.asset('assets/success.png'),
                    const SizedBox(height: 20),
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D6D6D),
                      ),
                    ),
                    const Text(
                      'Your request has been approved',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Space between sections
                // Next Steps
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    // Checklist
                    _buildCheckListItem(
                        'Get your request approved', true), // Checked
                    _buildCheckListItem(
                        'Make payment of 10 AED', false), // Unchecked
                    _buildCheckListItem(
                        'Receive payment confirmation', false), // Unchecked
                    _buildCheckListItem('You are all in!', false), // Unchecked
                  ],
                ),
                const Spacer(),
                // Continue to Payment Button
                Consumer(
                  builder: (context, ref, child) {
                    log('im inside continue to payment');
                    return customButton(
                        label: 'Continue to Payment',
                        onPressed: () async {
                          ApiRoutes userApi = ApiRoutes();
                          String? paymentUrl = await userApi.makePayment();
                          if (paymentUrl != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaymentWebView(
                                      paymentUrl: paymentUrl,
                                    )));
                          }
                        },
                        fontSize: 16);
                  },
                ),
                const SizedBox(height: 30), // Bottom padding
              ],
            ),
          ),
        ),
      );
    } else {
      if (!LoggedIn) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  children: [
                    
                    Positioned(
                        top: 130,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 210,  // adjust size as needed
                                height: 210,
                                decoration:  const BoxDecoration(
                                  color: Color(0xFFFFFEEF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 180,  // adjust size as needed
                                height: 180,
                                decoration:  const BoxDecoration(
                                  color: Color(0xFFFFF8EF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Image.asset(
                                'assets/success.png',
                                scale: .7,
                              ),
                            ],
                          ),
                        ),
                      ),
                                          const Positioned(
                      top: 400,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Coming Soon!',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                        top: 440,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              'You Will Receive Payment Link Soon',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Do not delete the App',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                    Positioned(
                        top: 500,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Checklist
                              _buildCheckListItem(
                                  'Get your request approved', true), // Checked
                              _buildCheckListItem(
                                  'Make payment of 10 AED', false), // Unchecked
                              _buildCheckListItem(
                                  'Receive payment confirmation',
                                  false), // Unchecked
                              _buildCheckListItem(
                                  'You are all in!', false), // Unchecked
                            ],
                          ),
                        )),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      right: 20,
                      child: Consumer(
                        builder: (context, ref, child) {
                          return customButton(
                              label: 'Done',
                              onPressed: () async {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileCompletionScreen()));
                              },
                              fontSize: 16,
                              buttonColor: Colors.white,
                              labelColor: Colors.black,
                              sideColor: Colors.white);
                        },
                      ),
                    ),
                  ],
                )),
          ),
        );
      } else {
        return ProfileCompletionScreen();
      }
    }
  }

  // Helper method to create checklist items
  Widget _buildCheckListItem(String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            isChecked ? 'assets/tic.png' : 'assets/untic.png',
            // color: isChecked ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isChecked ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
