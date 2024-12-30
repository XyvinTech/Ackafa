import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:ackaf/src/data/notifires/bookings_notifier.dart';
import 'package:ackaf/src/data/notifires/feed_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/hall_api.dart';
import 'package:ackaf/src/interface/common/customModalsheets.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/menu/book_hall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HallBookingPage extends ConsumerStatefulWidget {
  const HallBookingPage({super.key});

  @override
  _HallBookingPageState createState() => _HallBookingPageState();
}

class _HallBookingPageState extends ConsumerState<HallBookingPage> {
  int selectedTab = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(bookingsNotifierProvider.notifier).fetchMoreBookings();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(bookingsNotifierProvider.notifier).fetchMoreBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(bookingsNotifierProvider);
    final isLoading = ref.read(bookingsNotifierProvider.notifier).isLoading;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Hall Booking',
          style: TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: .5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),

            // // Tab Buttons
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     _buildTabButton('ONGOING', 0),
            //     _buildTabButton('UPCOMING', 1),
            //     _buildTabButton('COMPLETED', 2),
            //   ],
            // ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: bookings.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == bookings.length) {
                    return Center(child: LoadingAnimation());
                  }
                  return _buildBookingCard(bookings[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookHallPage()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // // Build Tab Button
  // Widget _buildTabButton(String title, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedTab = index;
  //       });
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //       decoration: BoxDecoration(
  //         color: selectedTab == index ? Colors.red[50] : Colors.transparent,
  //         border: Border.all(
  //           color: selectedTab == index ? Colors.red : Colors.grey,
  //         ),
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //       child: Text(
  //         title,
  //         style: TextStyle(
  //           color: selectedTab == index ? Colors.red : Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBookingCard(HallBooking? booking) {
    String date = DateFormat('yyyy-MM-dd').format(booking!.date!);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => HallModalSheet(
            booking: booking,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.event, color: Colors.red),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.hall ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(date ?? ''),
                    Text(
                        '${booking.time?.start ?? ''} - ${booking.time?.end ?? ''}'),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status ?? '').withOpacity(.25),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  booking.status ?? '',
                  style: TextStyle(
                      color: _getStatusColor(booking.status ?? ''),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
