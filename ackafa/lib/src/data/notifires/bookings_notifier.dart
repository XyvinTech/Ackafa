import 'dart:developer';

import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/api_routes/feed_api.dart';
import 'package:ackaf/src/data/services/api_routes/hall_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bookings_notifier.g.dart';

@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  List<HallBooking> bookings = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<HallBooking> build() {
    return [];
  }

  Future<void> fetchMoreBookings() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newBookings = await ref
          .read(fetchMyHallBookingsProvider(pageNo: pageNo, limit: limit).future);
      bookings = [...bookings, ...newBookings];
      pageNo++;
      hasMore = newBookings.length == limit;
      state = bookings;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshBookings() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedBookings = await ref
          .read(fetchMyHallBookingsProvider(pageNo: pageNo, limit: limit).future);
      bookings = refreshedBookings;
      hasMore = refreshedBookings.length == limit;
      state = bookings; 
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
