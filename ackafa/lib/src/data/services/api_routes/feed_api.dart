import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/globals.dart';

import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'feed_api.g.dart';

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
Future<List<Feed>> fetchAdminPublishedFeeds(FetchAdminPublishedFeedsRef ref,
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
Future<List<Feed>> fetchAdminFeeds(FetchAdminFeedsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  log('Requesting Admin feeds');
  final response = await http.get(
    Uri.parse('$baseUrl/feeds/admin/list?pageNo=$pageNo&limit=$limit'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final feedsJson = data['data'] as List<dynamic>? ?? [];
    log(feedsJson.toString());
    return feedsJson.map((user) => Feed.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load feeds');
  }
}

@riverpod
Future<List<Feed>> fetchAdminRejectedFeeds(FetchAdminRejectedFeedsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  log('Requesting Admin feeds');
  final response = await http.get(
    Uri.parse('$baseUrl/feeds/admin/list?status=rejected&pageNo=$pageNo&limit=$limit'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final feedsJson = data['data'] as List<dynamic>? ?? [];
    log(feedsJson.toString());
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

Future<bool?> updateFeedStatus(
    String action, String feedId) async {
  final url = Uri.parse('$baseUrl/feeds/single/$action/$feedId');
  final response = await http.put(url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"status": "cancelled"}));

  if (response.statusCode == 200) {

    print(json.decode(response.body)['message']);

    return true;
  } else {
    print(json.decode(response.body)['message']);

    print('Failed. Status code: ${response.statusCode}');
    return false;
  }
}
