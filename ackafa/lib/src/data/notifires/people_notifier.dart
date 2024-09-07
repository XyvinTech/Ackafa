import 'dart:developer';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'people_notifier.g.dart';

@riverpod
class PeopleNotifier extends _$PeopleNotifier {
  List<UserModel> users = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<UserModel> build() {
    return [];
  }

  Future<void> fetchMoreUsers() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newUsers = await ref
          .read(fetchUsersProvider(pageNo: pageNo, limit: limit).future);
      users = [...users, ...newUsers];
      pageNo++;
      hasMore = newUsers.length == limit;
      state = users;
    } catch (e, stackTrace) {
      log(e.toString());

      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
