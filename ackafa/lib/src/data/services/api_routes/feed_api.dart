import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'feed_api.g.dart';

const String baseUrl = 'http://3.108.205.101:3000/api/v1';

@riverpod
Future<List<Feed>> fetchFeeds(
    FetchFeedsRef ref, String token) async {
  final url = Uri.parse('$baseUrl/feeds/list');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Feed> feeds = [];

    for (var item in data) {
      feeds.add(Feed.fromJson(item));
    }
    print(feeds);
    return feeds;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
