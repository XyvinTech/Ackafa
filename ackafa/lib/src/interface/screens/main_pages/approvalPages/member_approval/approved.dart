import 'dart:developer';

import 'package:ackaf/src/data/notifires/approval_notifier.dart';
import 'package:ackaf/src/data/notifires/people_notifier.dart';
import 'package:ackaf/src/interface/common/approval_widgets/approval_pending_widget.dart';
import 'package:ackaf/src/interface/common/approval_widgets/approved_widget.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/profile/profilePreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApprovedApprovalPage extends ConsumerStatefulWidget {
  const ApprovedApprovalPage({super.key});

  @override
  ConsumerState<ApprovedApprovalPage> createState() =>
      _PendingApprovalPageState();
}

class _PendingApprovalPageState extends ConsumerState<ApprovedApprovalPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(usersNotifierProvider.notifier).fetchMoreUsers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(usersNotifierProvider.notifier).fetchMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = ref.watch(usersNotifierProvider);
    final users = allUsers.where((user) => user.status != 'inactive').toList();
    final isLoading = ref.read(usersNotifierProvider.notifier).isLoading;

    return Scaffold(
    
      body: users.isEmpty
          ? Center(child: Text('')) // Show loader when no data
          : ListView.builder(
              controller: _scrollController,
              itemCount: users.length + 1, // Add 1 for the loading indicator
              itemBuilder: (context, index) {
                if (index == users.length) {
                  return isLoading
                      ? Center(
                          child:
                              LoadingAnimation()) // Show loading when fetching more users
                      : SizedBox.shrink(); // Hide when done
                }

                final approval = users[index];
                return Column(
                  children: [
                    ApprovedWidget(
                      status: approval.status!,
                      imageUrl:
                          approval.image ?? '',
                      name: '${approval.fullName ?? ''}',
                      college: approval.college?.collegeName ?? '',
                      batch: 'Batch of: ${approval.batch.toString() ?? ''}',
                    ),
                    Divider(color: Color.fromARGB(255, 233, 227, 227)),
                  ],
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
