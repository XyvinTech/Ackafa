  import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/globals.dart';

part 'hall_api.g.dart';



@riverpod
Future<List<HallBooking>> fetchHallBookings(FetchHallBookingsRef ref,
   ) async {
  final response = await http.get(
    Uri.parse('$baseUrl/booking/list'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final hallbookingsJson = data['data'] as List<dynamic>? ?? [];

    return hallbookingsJson.map((hallBookings) => HallBooking.fromJson(hallBookings)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load feeds');
  }
}
  Future<void> bookHall(Map<String, dynamic> bookingData) async {
    final url = Uri.parse('$baseUrl/booking');
    log('updated profile data:$bookingData');
    final response = await http.patch(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(bookingData),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
      print(json.decode(response.body)['message']);
    } else {
      print(json.decode(response.body)['message']);
      print('Failed to update profile. Status code: ${response.statusCode}');
      throw Exception('Failed to update profile');
    }
  }