import 'dart:convert';
import 'package:ackaf/src/data/models/college_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'college_api.g.dart';

const String baseUrl = 'http://3.108.205.101:3000/api/v1';

@riverpod
Future<List<College>> fetchColleges(FetchCollegesRef ref, String token) async {
  final url = Uri.parse('$baseUrl/college/dropdown');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmQ0OTJlY2FiNmViMDA5NTRmMzE3YjkiLCJpYXQiOjE3MjUyNjQyNzN9.iA02JhzCHKHepzAjlIRVfrWv0GOuKipK5KqIV0ieQ9A"
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
