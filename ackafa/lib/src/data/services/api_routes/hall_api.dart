import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hall_api.g.dart';

@riverpod
Future<List<HallBooking>> fetchHallBookings(
    FetchHallBookingsRef ref, String date) async {
  log('requesting url:$baseUrl/time/bookings?date=$date');
  final response = await http.get(
    Uri.parse('$baseUrl/time/bookings?date=$date'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final hallbookingsJson = data['data'] as List<dynamic>? ?? [];
    log(data.toString());
    final List<HallBooking> hallbookings = hallbookingsJson
        .map((hallBookings) => HallBooking.fromJson(hallBookings))
        .toList();
    log(hallbookings.toString());
    return hallbookings;
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load feeds');
  }
}

Future<bool?> bookHall(
    Map<String, dynamic> bookingData, BuildContext context) async {
  final url = Uri.parse('$baseUrl/booking');
  log('creating data:$bookingData');
  final response = await http.post(
    url,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(bookingData),
  );

  if (response.statusCode == 200) {
    print('created hall booking successfully');
    print(json.decode(response.body)['message']);
    CustomSnackbar.showSnackbar(context, json.decode(response.body)['message']);
    return true;
  } else {
    print(json.decode(response.body)['message']);
    CustomSnackbar.showSnackbar(context, json.decode(response.body)['message']);
    print('Failed. Status code: ${response.statusCode}');
    return false;
  }
}
