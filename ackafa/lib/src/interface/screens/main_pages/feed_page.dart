import 'package:flutter/material.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/icons/ackaf_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              size: 21,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.menu,
              size: 21,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage()),
              );
            },
          ),
        ],
      ),
      body: FeedView(),
      
     
    );
  }
}
