import 'dart:developer';

import 'package:ackaf/src/data/notifires/approval_notifier.dart';
import 'package:ackaf/src/interface/common/approval_widgets/approval_pending_widget.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/profile/profilePreview_using_ID.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingApprovalPage extends ConsumerStatefulWidget {
  const PendingApprovalPage({super.key});

  @override
  ConsumerState<PendingApprovalPage> createState() =>
      _PendingApprovalPageState();
}

class _PendingApprovalPageState extends ConsumerState<PendingApprovalPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(approvalNotifierProvider.notifier).fetchMoreApprovals();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(approvalNotifierProvider.notifier).fetchMoreApprovals();
    }
  }

  @override
  Widget build(BuildContext context) {
    final approvals = ref.watch(approvalNotifierProvider);
    final isLoading = ref.read(approvalNotifierProvider.notifier).isLoading;
    log('pending approvals :$approvals');
    return Scaffold(  
      body: approvals.isEmpty
          ? Center(
              child: Text('NO PENDING APPROVALS')) // Show loader when no data
          : ListView.builder(
              controller: _scrollController,
              itemCount:
                  approvals.length + 1, // Add 1 for the loading indicator
              itemBuilder: (context, index) {
                if (index == approvals.length) {
                  return isLoading
                      ? Center(
                          child:
                              LoadingAnimation()) // Show loading when fetching more users
                      : SizedBox.shrink(); // Hide when done
                }

                final approval = approvals[index];
                return Column(
                  children: [
                    ApprovalPendingWidget(
                      userId: approval.id!,
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
