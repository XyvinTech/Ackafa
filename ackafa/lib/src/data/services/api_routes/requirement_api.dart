import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'requirement_api.g.dart';

const String baseUrl = 'http://43.205.89.79/api/v1';

@riverpod
Future<List<Requirement>> fetchRequirements(
    FetchRequirementsRef ref, String token) async {
  final url = Uri.parse('$baseUrl/requirements');
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
    List<Requirement> events = [];

    for (var item in data) {
      events.add(Requirement.fromJson(item));
    }
    print(events);
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
