import 'dart:developer';
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/api_routes/feed_api.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'feed_approval_notifier.g.dart';

@riverpod
class FeedApprovalNotifier extends _$FeedApprovalNotifier {
  List<Feed> approvalFeeds = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<Feed> build() {
    return [];
  }

  Future<void> fetchMoreFeed() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newApprovalFeeds = await ref
          .read(fetchAdminFeedsProvider(pageNo: pageNo, limit: limit).future);
      approvalFeeds = [...approvalFeeds, ...newApprovalFeeds];
      pageNo++;
      hasMore = newApprovalFeeds.length == limit;
      state = approvalFeeds;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshFeed() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedApprovalFeeds = await ref
          .read(fetchAdminFeedsProvider(pageNo: pageNo, limit: limit).future);
      approvalFeeds = refreshedApprovalFeeds;
      hasMore = refreshedApprovalFeeds.length == limit;
      state = approvalFeeds; // Update the state with the refreshed feed\
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}


@riverpod
class FeedApprovalRejectedNotifier extends _$FeedApprovalRejectedNotifier {
  List<Feed> approvalFeeds = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<Feed> build() {
    return [];
  }

  Future<void> fetchMoreFeed() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newApprovalFeeds = await ref
          .read(fetchAdminRejectedFeedsProvider(pageNo: pageNo, limit: limit).future);
      approvalFeeds = [...approvalFeeds, ...newApprovalFeeds];
      pageNo++;
      hasMore = newApprovalFeeds.length == limit;
      state = approvalFeeds;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshFeed() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedApprovalFeeds = await ref
          .read(fetchAdminRejectedFeedsProvider(pageNo: pageNo, limit: limit).future);
      approvalFeeds = refreshedApprovalFeeds;
      hasMore = refreshedApprovalFeeds.length == limit;
      state = approvalFeeds; // Update the state with the refreshed feed\
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}

@riverpod
class FeedApprovalPublishedNotifier extends _$FeedApprovalPublishedNotifier {
  List<Feed> approvalFeeds = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<Feed> build() {
    return [];
  }

  Future<void> fetchMoreFeed() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newApprovalFeeds = await ref
          .read(fetchAdminPublishedFeedsProvider(pageNo: pageNo, limit: limit).future);
      approvalFeeds = [...approvalFeeds, ...newApprovalFeeds];
      pageNo++;
      hasMore = newApprovalFeeds.length == limit;
      state = approvalFeeds;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshFeed() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedApprovalFeeds = await ref
          .read(fetchAdminPublishedFeedsProvider(pageNo: pageNo, limit: limit).future);
      approvalFeeds = refreshedApprovalFeeds;
      hasMore = refreshedApprovalFeeds.length == limit;
      state = approvalFeeds; // Update the state with the refreshed feed\
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
