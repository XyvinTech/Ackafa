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
  final int limit = 20;
  bool hasMore = true;
  String? searchQuery;

  @override
  List<UserModel> build() {
    return [];
  }

  Future<void> fetchMoreUsers() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    // Delay state update to avoid modifying during widget build
    Future(() {
      state = [...users];
    });

    try {
      final newUsers = await ref.read(fetchActiveUsersProvider(
              pageNo: pageNo, limit: limit, query: searchQuery)
          .future);

      users = [...users, ...newUsers];
      pageNo++;
      hasMore = newUsers.length == limit;

      // Delay state update to trigger rebuild after data is fetched
      Future(() {
        state = [...users];
      });
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;

      // Ensure state update after fetch completion
      Future(() {
        state = [...users];
      });

      log('Fetched users: $users');
    }
  }

  Future<void> searchUsers(String query) async {
    isLoading = true;
    pageNo = 1;
    users = []; // Reset the user list when searching
    searchQuery = query;

    try {
      final newUsers = await ref.read(
          fetchActiveUsersProvider(pageNo: pageNo, limit: limit, query: query)
              .future);

      users = [...newUsers];
      hasMore = newUsers.length == limit;

      state = [...users];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    pageNo = 1;
    hasMore = true;
    users = []; // Clear the current user list
    state = [...users]; // Update the state to reflect the cleared list

    try {
      final newUsers = await ref.read(fetchActiveUsersProvider(
              pageNo: pageNo, limit: limit, query: searchQuery)
          .future);

      users = [...newUsers];
      hasMore = newUsers.length == limit;

      state = [...users]; // Update the state with refreshed data
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}

@riverpod
class UsersNotifier extends _$UsersNotifier {
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
          .read(fetchAllUsersProvider(pageNo: pageNo, limit: limit).future);
      users = [...users, ...newUsers];
      pageNo++;
      hasMore = newUsers.length == limit;
      state = users;
    } catch (e, stackTrace) {
      log(e.toString());

      log(stackTrace.toString());
    } finally {
      isLoading = false;
      log('im in people $users');
    }
  }

  Future<void> refreshAllUsers() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedUsers = await ref
          .read(fetchAllUsersProvider(pageNo: pageNo, limit: limit).future);
      users = refreshedUsers;
      hasMore = refreshedUsers.length == limit;
      state = users; // Update the state with the refreshed feed\
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
