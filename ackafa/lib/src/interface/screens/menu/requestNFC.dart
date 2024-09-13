import 'package:flutter/material.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';

class RequestNFCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request NFC'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color.fromRGBO(51, 51, 51, 0.2),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect\nwith Ease',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE30613),
              ),
            ),
            Flexible(
              child: Text(
                  'Tired of carrying bulky business cards or typing out contact details? Upgrade to the future with our sleek NFC card! Just a simple tap, and your contact information, website, or social media instantly appears on any smartphone.'),
            ),
            SizedBox(height: 16),
            SizedBox(height: 24),
            Center(
              child: Image.asset(
                scale: 2.5,
                'assets/NFC.png', // Replace with your image URL
              ),
            ),
            customButton(label: 'REQUEST NFC', onPressed: () {}, fontSize: 16),
          ],
        ),
      ),
    );
  }
}
