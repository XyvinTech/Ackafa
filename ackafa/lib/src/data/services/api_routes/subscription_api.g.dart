// import 'dart:convert';
// import 'dart:developer';
// import 'package:ackaf/src/data/models/hall_models.dart';
// import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:ackaf/src/data/globals.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'subscription_api.g.dart';

// @riverpod
// Future<List<HallBooking>> fetchHallBookings(
//     FetchHallBookingsRef ref, String date) async {
//   log('requesting url:$baseUrl/time/bookings?date=$date');
//   final response = await http.get(
//     Uri.parse('$baseUrl/time/bookings?date=$date'),
//     headers: {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token"
//     },
//   );

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     final hallbookingsJson = data['data'] as List<dynamic>? ?? [];
//     log(data.toString());
//     final List<HallBooking> hallbookings = hallbookingsJson
//         .map((hallBookings) => HallBooking.fromJson(hallBookings))
//         .toList();
//     log(hallbookings.toString());
//     return hallbookings;
//   } else {
//     final data = json.decode(response.body);
//     log(data['message']);
//     throw Exception('Failed to load feeds');
//   }
// }
