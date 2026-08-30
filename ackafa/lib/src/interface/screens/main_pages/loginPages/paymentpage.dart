import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/constants/text_style.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/profile_completetion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({super.key});

  static const Color _subtitleColor = Color(0xFF757575);
  static const Color _cardFill = Color(0xFFF5F5F5);
  static const Color _buttonColor = Color(0xFFC60E18);
  static const double _horizontalPadding = 24.0;
  static const double _fieldRadius = 12.0;
  static const double _buttonHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    log("Paymetn enabled?:$isPaymentEnabled");
    if (isPaymentEnabled) {
      log('Im in not logged in condition');
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    _horizontalPadding,
                    48,
                    _horizontalPadding,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎉',
                        style: TextStyle(fontSize: 56),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "You're approved",
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'One last step — pay your membership fee to activate full access.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          color: _subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: _cardFill,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Annual Membership fee',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Text(
                              'AED 10',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding,
                  8,
                  _horizontalPadding,
                  24,
                ),
                child: SizedBox(
                  height: _buttonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Payment gateway integration will be added later.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_fieldRadius),
                      ),
                    ),
                    child: const Text(
                      'Pay',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                              width: 210,
                              height: 210,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFEEF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 180,
                              decoration: const BoxDecoration(
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
                            fontFamily: 'Fraunces',
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
                              style: AppTextStyles.subHeading18,
                            ),
                            Text(
                              'Do not delete the App',
                              style: AppTextStyles.subHeading18,
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
                              _buildCheckListItem(
                                  'Get your request approved', true),
                              _buildCheckListItem(
                                  'Make payment of 10 AED', false),
                              _buildCheckListItem(
                                  'Receive payment confirmation', false),
                              _buildCheckListItem('You are all in!', false),
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

  Widget _buildCheckListItem(String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            isChecked ? 'assets/tic.png' : 'assets/untic.png',
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Fraunces',
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
