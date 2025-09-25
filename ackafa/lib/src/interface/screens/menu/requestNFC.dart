import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:flutter/material.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';

class RequestNFCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Request NFC',
          style: TextStyle(fontSize: 17),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: [
        //   IconButton(
        //     icon: FaIcon(FontAwesomeIcons.whatsapp),
        //     onPressed: () {
        //       // WhatsApp action
        //     },
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
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
                fontFamily: 'HelveticaNeue',
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE30613),
              ),
            ),
            Flexible(
              child: Text(
                  'Tired of carrying bulky business cards or typing out contact details? Upgrade to the future with our sleek NFC card! Just a simple tap, and your contact information, website, or social media instantly appears on any smartphone.',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    color: Colors.grey
                  ),),
                  
            ),
            SizedBox(height: 16),
            SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                color: Color(0xFFFFF4B3),          // yellow background
                shape: BoxShape.circle,          // circular shape
              ),
                child: Image.asset(
                  scale: 2.5,
                  'assets/NFC.png', // Replace with your image URL
                ),
              ),
            ),
            customButton(
                label: 'REQUEST NFC',
                onPressed: () {
                  ApiRoutes userApi = ApiRoutes();
                  userApi.requestNFC(context);
                },
                fontSize: 16),
          ],
        ),
      ),
    );
  }
}
