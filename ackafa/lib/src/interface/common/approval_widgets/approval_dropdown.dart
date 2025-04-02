import 'package:flutter/material.dart';

class ApproveDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert), // The icon to trigger the dropdown
      onPressed: () {
        showMenu(
          color: Colors.white,
          context: context,
          position:
              RelativeRect.fromLTRB(100, 100, 0, 0), // Position of the dropdown
          items: [
            PopupMenuItem(
              child: Text(
                'Approve',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () => _approveAction(),
            ),
            PopupMenuItem(
              child: Text(
                'Reject',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _rejectAction(),
            ),
          ],
        );
      },
    );
  }

  void _approveAction() {
    // Add your "Approve" function logic here
    print('Approved');
  }

  void _rejectAction() {
    // Add your "Reject" function logic here
    print('Rejected');
  }
}
