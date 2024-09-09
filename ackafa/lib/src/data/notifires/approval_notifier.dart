import 'dart:developer';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/api_routes/approval_api.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'approval_notifier.g.dart';

@riverpod
class ApprovalNotifier extends _$ApprovalNotifier {
  List<UserModel> approvals = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<UserModel> build() {
    return [];
  }

  Future<void> fetchMoreApprovals() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newApprovals = await ref
          .read(fetchApprovalsProvider(pageNo: pageNo, limit: limit).future);
      approvals = [...approvals, ...newApprovals];
      pageNo++;
      hasMore = newApprovals.length == limit;
      state = approvals;
    } catch (e, stackTrace) {
      log(e.toString());

      log(stackTrace.toString());
    } finally {
      isLoading = false;
      log('im in people $approvals');
    }
  }

  Future<void> refreshApprovals() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshApprovals = await ref
          .read(fetchApprovalsProvider(pageNo: pageNo, limit: limit).future);
      approvals = refreshApprovals;
      hasMore = refreshApprovals.length == limit;
      state = approvals; // Update the state with the refreshed feed\
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
