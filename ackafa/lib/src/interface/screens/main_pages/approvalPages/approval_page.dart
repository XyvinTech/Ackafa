import 'package:ackaf/src/interface/screens/main_pages/approvalPages/pending.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:ackaf/src/interface/screens/people/chat/chat.dart';
import 'package:ackaf/src/interface/screens/people/members.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3, // Number of tabs

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
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    size: 21,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
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
                preferredSize: const Size.fromHeight(80),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_back),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Approvals',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 0), // Adjust this value to reduce space
                      child: const SizedBox(
                        height: 40,
                        child: TabBar(
                          isScrollable:
                              false, // Disable scroll to center the tabs
                          indicatorColor: Color(
                              0xFFE30613), // Set to AppPalette.kPrimaryColor
                          indicatorWeight: 3.0,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Color(0xFFE30613),
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(text: "PENDING"),
                            Tab(text: "APPROVED"),
                            Tab(text: "REJECTED"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: const Column(
              children: [
                // Wrap TabBar with a Container to adjust margin

                Expanded(
                  child: TabBarView(
                    children: [
                      PendingApprovalPage(),
                      PendingApprovalPage(),
                      PendingApprovalPage()
                    ],
                  ),
                ),
              ],
            )));
  }
}
