import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:flutter/material.dart';

class PaymentConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // Spacing from top
              // Congratulations Icon and Text
              Column(
                children: [
                  // Icon for congratulation (can be replaced with an asset image)
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
                  const Text(
                    'Next steps!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Gain full access to the app by making',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'a',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        ' One-Time-Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF7C7C7C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
              customButton(
                  label: 'Continue to Payment', onPressed: () {}, fontSize: 16),
              const SizedBox(height: 30), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create checklist items
  Widget _buildCheckListItem(String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isChecked ? Icons.check : Icons.check,
            color: isChecked ? Colors.red : Colors.grey,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
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
