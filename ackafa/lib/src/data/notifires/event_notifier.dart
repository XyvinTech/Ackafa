// events_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/data/services/api_routes/events_api.dart';

class EventsNotifier extends StateNotifier<List<Event>> {
  final Ref ref;
  bool isLoading = false;
  bool isFirstLoad = true;

  EventsNotifier(this.ref) : super([]);

  /// Initial load / normal fetch
  Future<void> fetchEvents() async {
    try {
      isLoading = true;
      if (isFirstLoad) state = [];
      // IMPORTANT: use ref.read(... .future) to get the Future<List<Event>>
      final List<Event> events = await ref.read(fetchEventsProvider.future);
      state = events;
      isFirstLoad = false;
    } catch (e, st) {
      // optional: log the error
      debugPrint('fetchEvents error: $e\n$st');
      // keep isFirstLoad false so UI doesn't stay in infinite spinner
      isFirstLoad = false;
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  /// Pull-to-refresh
  Future<void> refreshEvents() async {
    isFirstLoad = true;
    await fetchEvents();
  }

  /// Load more (simple append). Avoids type issues by typing `newEvents`.
  Future<void> fetchMoreEvents() async {
    if (isLoading) return;
    try {
      isLoading = true;
      final List<Event> newEvents = await ref.read(fetchEventsProvider.future);
      // Simple append — if you need deduplication, see comment below.
      state = [...state, ...newEvents];
    } catch (e, st) {
      debugPrint('fetchMoreEvents error: $e\n$st');
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}

/// Provider
final eventsNotifierProvider =
    StateNotifierProvider<EventsNotifier, List<Event>>(
  (ref) => EventsNotifier(ref)..fetchEvents(),
);
