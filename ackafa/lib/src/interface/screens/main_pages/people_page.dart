import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';
import 'package:kssia/src/interface/screens/people/chat/chat.dart';
import 'package:kssia/src/interface/screens/people/members.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Consumer(
        builder: (context, ref, child) {
          final asyncUsers = ref.watch(fetchUsersProvider(token));

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
                    'assets/icons/kssiaLogo.png',
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
                          Color(0xFF004797), // Set to AppPalette.kPrimaryColor
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Color(0xFF004797),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: "MEMBERS"),
                        Tab(text: "CHAT"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: asyncUsers.when(
              data: (users) {
                return Column(
                  children: [
                    // Wrap TabBar with a Container to adjust margin

                    Expanded(
                      child: TabBarView(
                        children: [
                          MembersPage(users: users),
                          ChatPage(),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                print(stackTrace);
                return Center(
                  child: Text('Error loading users: $error'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
