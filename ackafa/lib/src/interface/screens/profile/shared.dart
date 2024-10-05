import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/icons/ackaf_logo.png', height: 30),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button pressed
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu button pressed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Image.asset(
                                'assets/icons/show_hide_button.png'),
                            onPressed: () {
                              // Handle show/hide button pressed
                            },
                          ),
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133351928-stock-illustration-default-placeholder-man-and-woman.jpg'),
                              onBackgroundImageError: (_, __) =>
                                  AssetImage('assets/icons/default_avatar.png'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'John Fitzgerald',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/volkswagenLogo.png',
                                  height: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Chief Financial Officer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Company Name',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/icons/QR_card.png', // Ensure this path is correct
                      height: 200, // Adjust height as needed
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('+91 9458652637'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('johndoe@gmail.com'),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle share button pressed
                    },
                    child: Text('SHARE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle download QR button pressed
                    },
                    child: Text('DOWNLOAD QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
