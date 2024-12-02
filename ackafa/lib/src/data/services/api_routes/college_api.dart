import 'dart:convert';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/college_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'college_api.g.dart';



@riverpod
Future<List<College>> fetchColleges(FetchCollegesRef ref, String token) async {
  final url = Uri.parse('$baseUrl/college/dropdown');
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
    List<College> colleges = [];

    for (var item in data) {
      colleges.add(College.fromJson(item));
    }
    print(colleges);
    return colleges;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
