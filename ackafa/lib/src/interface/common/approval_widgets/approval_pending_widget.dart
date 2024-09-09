import 'package:ackaf/src/data/notifires/approval_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/approval_api.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApprovalPendingWidget extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String name;
  final String college;
  final String batch;

  const ApprovalPendingWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.college,
    required this.batch,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    ApiRoutes userApi = ApiRoutes();

    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(imageUrl),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  college,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  batch,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: Icon(Icons.more_vert), // Trigger icon
                items: [
                  DropdownMenuItem(
                    value: 'approve',
                    child: Text(
                      'Approve',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'reject',
                    child: Text(
                      'Reject',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                onChanged: (value) async {
                  if (value == 'approve') {
                    bool result = await userApi.updateUserStatus(
                        userId: userId, status: 'awaiting_payment', reason: '');

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Approved')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed')));
                    }
                    ref
                        .read(approvalNotifierProvider.notifier)
                        .refreshApprovals();
                  } else if (value == 'reject') {
                    await userApi.updateUserStatus(
                        userId: userId, status: 'rejected', reason: '');
                    ref
                        .read(approvalNotifierProvider.notifier)
                        .refreshApprovals();
                  }
                },
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  offset: const Offset(0, 0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
