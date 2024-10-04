import 'dart:convert';
import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/chatMember_model.dart';
import 'package:ackaf/src/data/models/group_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_api.g.dart';

const String baseUrl = 'https://akcafconnect.com/api/v1';

@riverpod
Future<List<GroupModel>> getGroupList(
  GetGroupListRef ref,
) async {
  final response = await http.get(
    Uri.parse('$baseUrl/chat/list-group'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final groupsJson = data['data'] as List<dynamic>? ?? [];

    return groupsJson.map((user) => GroupModel.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load Groups');
  }
}

@riverpod
Future<List<GroupMember>> getGroupMembers(GetGroupMembersRef ref,
    {required String groupId}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/chat/group-details/$groupId'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final groupsJson = data['data'] as List<dynamic>? ?? [];

    return groupsJson.map((user) => GroupMember.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load group details');
  }
}
