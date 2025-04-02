import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:ackaf/src/data/models/subscription_model.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_api.g.dart';

@riverpod
Future<SubscriptionModel> fetchSubscriptionDetails(Ref ref) async {
  final url = Uri.parse('$baseUrl/user/subscription/$id');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  log(response.body);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];

    return SubscriptionModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
