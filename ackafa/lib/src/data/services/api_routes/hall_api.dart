import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hall_api.g.dart';

@riverpod
Future<List<HallBooking>> fetchHallBookings(
    FetchHallBookingsRef ref, String date, String hallId) async {
  log('requesting url:$baseUrl/time/bookings?date=$date&hall=$hallId');
  final response = await http.get(
    Uri.parse('$baseUrl/time/bookings?date=$date&hall=$hallId'),
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

@riverpod
Future<List<DateTime?>> fetchBookedDates(
    FetchBookedDatesRef ref, String month) async {
  log('requesting url:$baseUrl/booking/calendar/$month');
  final response = await http.get(
    Uri.parse('$baseUrl/booking/calendar/$month'),
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
    final List<DateTime?> bookedDates =
        hallbookings.map((booking) => booking.date).toSet().toList();
    log(hallbookings.toString());
    return bookedDates ?? [];
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    return [];
  }
}

@riverpod
Future<List<Hall>> fetchHalls(FetchHallsRef ref) async {
  log('requesting url:$baseUrl/booking/dropdown');
  final response = await http.get(
    Uri.parse('$baseUrl/booking/dropdown'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final hallbookingsJson = data['data'] as List<dynamic>? ?? [];
    log(data.toString());
    final List<Hall> hallbookings = hallbookingsJson
        .map((hallBookings) => Hall.fromJson(hallBookings))
        .toList();
    log(hallbookings.toString());
    return hallbookings;
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load feeds');
  }
}

@riverpod
Future<List<HallBooking>> fetchMyHallBookings(FetchMyHallBookingsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  log('requesting url:$baseUrl/booking/list');
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



@riverpod
Future<List<AvailableTimeModel>> fetchHallTimes(Ref ref) async {
  final url = Uri.parse('$baseUrl/time');
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
    List<AvailableTimeModel> news = [];

    for (var item in data) {
      news.add(AvailableTimeModel.fromJson(item));
    }
    print(news);
    return news;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
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

  if (response.statusCode == 200 || response.statusCode == 201) {
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

Future<bool?> cancelBooking(String bookingId, BuildContext context) async {
  final url = Uri.parse('$baseUrl/booking/edit/$bookingId');
  final response = await http.put(url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"status": "cancelled"}));

  if (response.statusCode == 200) {
    print('cancelled hall booking successfully');
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
