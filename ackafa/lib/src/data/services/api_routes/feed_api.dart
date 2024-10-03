import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/globals.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'feed_api.g.dart';

const String baseUrl = 'http://akcafconnect.com/api/v1';
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

@riverpod
Future<List<Feed>> fetchMyPosts(FetchMyPostsRef ref) async {
  final url = Uri.parse('$baseUrl/feeds/my-feeds');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Feed> posts = [];

    for (var item in data) {
      posts.add(Feed.fromJson(item));
    }
    print(posts);
    return posts;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
