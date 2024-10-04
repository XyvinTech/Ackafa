import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/interface/screens/people/chat/groupchat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:ackaf/src/interface/screens/people/chat/chat.dart';
import 'package:ackaf/src/interface/screens/people/members.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, // Number of tabs

        child: Scaffold(
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
                          builder: (context) =>
                              MenuPage()), // Navigate to MenuPage
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: Container(
                  margin: EdgeInsets.only(
                      top: 0), // Adjust this value to reduce space
                  child: const SizedBox(
                    height: 40,
                    child: TabBar(
                      isScrollable: false, // Disable scroll to center the tabs
                      indicatorColor:
                          Color(0xFFE30613), // Set to AppPalette.kPrimaryColor
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Color(0xFFE30613),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: "CHAT"),
                        // Tab(text: "GROUP CHAT"),
                        Tab(text: "MEMBERS"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                // Wrap TabBar with a Container to adjust margin

                Expanded(
                  child: TabBarView(
                    children: [
                      ChatPage(),
                      // GroupChatPage(),
                      MembersPage(),
                    ],
                  ),
                ),
              ],
            )));
  }
}
