import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'approval_api.g.dart';



@riverpod
Future<List<UserModel>> fetchApprovals(FetchApprovalsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/user/approvals?pageNo=$pageNo&limit=$limit'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final usersJson = data['data'] as List<dynamic>? ?? [];
    log(usersJson.toString());

    return usersJson.map((user) => UserModel.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load users');
  }
}
