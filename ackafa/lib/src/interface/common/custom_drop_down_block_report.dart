import 'dart:developer';

import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/models/msg_model.dart';
import 'package:ackaf/src/data/notifires/feed_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/custom_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDown extends ConsumerWidget {
  final Feed? feed;

  final MessageModel? msg;
  final String? userId;
  final VoidCallback? onBlockStatusChanged;
  final bool? isBlocked;

  const CustomDropDown({
    this.onBlockStatusChanged,
    this.userId,
    this.msg,
    super.key,
    this.feed,
    this.isBlocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ApiRoutes userApi = ApiRoutes();
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(Icons.more_vert), // Trigger icon
        items: [
          const DropdownMenuItem(
            value: 'report',
            child: const Text(
              'Report',
              style: TextStyle(color: Colors.red),
            ),
          ),
          DropdownMenuItem(
            value: 'block',
            child: isBlocked != null && isBlocked == false
                ? Text(
                    'Block',
                    style: TextStyle(color: Colors.red),
                  )
                : Text(
                    'Unblock',
                    style: TextStyle(color: Colors.red),
                  ),
          ),
        ],
        onChanged: (value) async {
          if (value == 'report') {
            String reportType = '';
            if (feed != null) {
              reportType = 'Post';
              showReportPersonDialog(
                  reportedItemId: feed?.id ?? '',
                  context: context,
                  onReportStatusChanged: () {},
                  reportType: reportType);
            } else if (userId != null) {
              log(userId.toString());
              reportType = 'User';
              showReportPersonDialog(
                  reportedItemId: userId ?? '',
                  context: context,
                  userId: userId ?? '',
                  onReportStatusChanged: () {},
                  reportType: reportType);
            } else {
              reportType = 'Chat';
              showReportPersonDialog(
                  reportedItemId: msg?.id ?? '',
                  context: context,
                  onReportStatusChanged: () {},
                  reportType: reportType);
            }
          } else if (value == 'block') {
            if (feed != null) {
              showBlockPersonDialog(
                  context: context,
                  userId: feed?.author?.id ?? '',
                  onBlockStatusChanged: () {
                    ref.invalidate(feedNotifierProvider);
                  });
            } else if (userId != null) {
              showBlockPersonDialog(
                  context: context,
                  userId: userId ?? '',
                  onBlockStatusChanged: () {
                    onBlockStatusChanged;
                  });
            }
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
    );
  }
}
