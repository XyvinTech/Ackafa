import 'dart:developer';

import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/api_routes/feed_api.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'feed_notifier.g.dart';

@riverpod
class FeedNotifier extends _$FeedNotifier {
  List<Feed> feeds = [];
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
      final newFeeds = await ref
          .read(fetchFeedsProvider(pageNo: pageNo, limit: limit).future);
      feeds = [...feeds, ...newFeeds];
      pageNo++;
      hasMore = newFeeds.length == limit;
      state = feeds;
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
      final refreshedFeeds = await ref
          .read(fetchFeedsProvider(pageNo: pageNo, limit: limit).future);
      feeds = refreshedFeeds;
      hasMore = refreshedFeeds.length == limit;
      state = feeds; // Update the state with the refreshed feed\
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
