import 'dart:developer';

import 'package:ackaf/src/data/notifires/approval_notifier.dart';
import 'package:ackaf/src/data/notifires/people_notifier.dart';
import 'package:ackaf/src/interface/common/approval_widgets/approval_pending_widget.dart';
import 'package:ackaf/src/interface/common/approval_widgets/approval_rejected_widget.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RejectedApprovalPage extends ConsumerStatefulWidget {
  const RejectedApprovalPage({super.key});

  @override
  ConsumerState<RejectedApprovalPage> createState() =>
      _PendingApprovalPageState();
}

class _PendingApprovalPageState extends ConsumerState<RejectedApprovalPage> {
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
    final users = allUsers.where((user) => user.status == 'rejected').toList();
    final isLoading = ref.read(usersNotifierProvider.notifier).isLoading;
    log('pending approvals :$users');
    return Scaffold(
      backgroundColor: Colors.white,
      body: users.isEmpty
          ? Center(child: Text('NO REJECTIONS')) // Show loader when no data
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

                final user = users[index];
                return Column(
                  children: [
                    ApprovalRejectedWidget(
                      imageUrl:
                          user.image ?? 'https://placehold.co/600x400/png',
                      name:
                          '${user.name?.first} ${user.name?.middle} ${user.name?.last}',
                      college: user.college?.collegeName ?? '',
                      batch: 'Batch of: ${user.batch.toString() ?? ''}',
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
