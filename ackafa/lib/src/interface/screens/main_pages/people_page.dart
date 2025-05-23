import 'package:ackaf/src/interface/common/components/app_bar.dart';
import 'package:ackaf/src/interface/screens/people/chat/groupchat.dart';
import 'package:flutter/material.dart';
import 'package:ackaf/src/interface/screens/people/chat/chat.dart';
import 'package:ackaf/src/interface/screens/people/members.dart';


class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3, // Number of tabs

        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(
              iselevationNeeded: false,
            ),
            body: Column(
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(20),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 0), // Adjust this value to reduce space
                    child: const SizedBox(
                      height: 40,
                      child: TabBar(
                        enableFeedback: true,
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
                          Tab(text: "CHAT"),
                          Tab(text: "GROUP CHAT"),
                          Tab(text: "MEMBERS"),
                        ],
                      ),
                    ),
                  ),
                ),
                // Wrap TabBar with a Container to adjust margin

                Expanded(
                  child: TabBarView(
                    children: [
                      ChatPage(),
                      GroupChatPage(),
                      MembersPage(),
                    ],
                  ),
                ),
              ],
            )));
  }
}
