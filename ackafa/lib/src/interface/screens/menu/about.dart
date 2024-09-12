import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/about_us.png'),
            SizedBox(height: 16),
            SizedBox(height: 8),
            Text(
              'AKCAF is an association registered under the Community Development Authority (CDA), Dubai. The members are various College Alumni from over a 100 colleges in Kerala, India. It seeks to promote the group’s ethnic and cultural values on a local and global level through its various social and cultural activities.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, color: Color(0xFFE30613)),
                SizedBox(width: 10),
                Text('+971 50 502 8275', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Color(0xFFE30613)),
                SizedBox(width: 10),
                Text('secretary@akcaf.org', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black), // Default style for body
                children: [
                  TextSpan(
                    text: 'Mission:\n',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold), // Style for heading
                  ),
                  TextSpan(
                    text:
                        'AKCAF strives to utilize the power of nostalgia and friendships forged in college campuses for the betterment of the society at large. Pride, loyalty and future sustainment are the driving forces behind AKCAF; with its members contributing to various philanthropic activities both in UAE and Kerala.\n\n',
                  ),

                  TextSpan(
                    text: 'Vision: \n',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold), // Style for heading
                  ),
                  TextSpan(
                    text:
                        '''In compliance with UAE laws, AKCAF’s aims to foster new connections between the two great nations with a deep commitment to support and serve the community in a dedicated and selfless manner.\n\n''',
                  ),
                  // Add the rest of the sections similarly
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
