// import 'dart:developer';

// import 'package:ackaf/src/data/models/group_model.dart';
// import 'package:ackaf/src/data/services/api_routes/group_api.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// part 'grouplist_notifier.g.dart';

// @riverpod
// class GrouplistNotifier extends _$GrouplistNotifier {
//   List<GroupModel> groups = [];
//   bool isLoading = false;
//   int pageNo = 1;
//   final int limit = 20;
//   bool hasMore = true;

//   @override
//   List<GroupModel> build() {
//     return [];
//   }

//   Future<void> fetchMoreGroupList() async {
//     if (isLoading || !hasMore) return;

//     isLoading = true;

//     try {
//       final newGroups = await ref
//           .read(getGroupListProvider(pageNo: pageNo, limit: limit).future);
//       groups = [...groups, ...newGroups];
//       pageNo++;
//       hasMore = newGroups.length == limit;
//       state = groups;
//     } catch (e, stackTrace) {
//       log(e.toString());

//       log(stackTrace.toString());
//     } finally {
//       isLoading = false;
//       log('im in groups $groups');
//     }
//   }
// }

