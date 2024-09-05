import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/globals.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'feed_api.g.dart';

const String baseUrl = 'http://3.108.205.101:3000/api/v1';
@riverpod
Future<List<Feed>> fetchFeeds(FetchFeedsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/feeds/list?pageNo=$pageNo&limit=$limit'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final feedsJson = data['data'] as List<dynamic>? ?? [];

    return feedsJson.map((user) => Feed.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load feeds');
  }
}
