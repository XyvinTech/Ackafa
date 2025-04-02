import 'package:flutter/material.dart';
import 'member_approval/pending.dart';
import 'member_approval/approved.dart';
import 'member_approval/rejected.dart';

class MemberApproval extends StatefulWidget {
  const MemberApproval({Key? key}) : super(key: key);

  @override
  _MemberApprovalState createState() => _MemberApprovalState();
}

class _MemberApprovalState extends State<MemberApproval> {
  int _selectedIndex = 0;

  final List<String> _tabLabels = ["PENDING", "APPROVED", "REJECTED"];
  final List<Widget> _pages = [
    const PendingApprovalPage(),
    const ApprovedApprovalPage(),
    const RejectedApprovalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_tabLabels.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedIndex == index ? Colors.red[50] : Colors.transparent,
                  border: Border.all(
                    color: _selectedIndex == index ? Colors.red : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  _tabLabels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _selectedIndex == index ? Colors.red : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: _pages[_selectedIndex],
        ),
      ],
    );
  }

}
