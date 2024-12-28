import 'package:ackaf/src/interface/screens/main_pages/approvalPages/feed_approval.dart';
import 'package:ackaf/src/interface/screens/main_pages/approvalPages/member_approval.dart';
import 'package:ackaf/src/interface/screens/people/members.dart';
import 'package:flutter/material.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({Key? key}) : super(key: key);

  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
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
          ],
        ),
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: 13),
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(
              text: "MEMBER",
            ),
            Tab(text: "FEED"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MemberApproval(),
          FeedApproval(),
        ],
      ),
    );
  }
}
