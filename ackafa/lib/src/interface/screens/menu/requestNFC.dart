import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/custom_button.dart';

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
              'Connect            with Ease',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE30613),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Justo facilisis mattis tincidunt vitae quam quis. Nec nisi duis amet aenean arcu tristique et et eleifend.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF828282),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Image.network(
                'https://placehold.co/600x400/png', // Replace with your image URL
                height: 200,
              ),
            ),
            SizedBox(height: 69),
            Center(
                child: customButton(
                    label: 'REQUEST NFC', onPressed: () {}, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
