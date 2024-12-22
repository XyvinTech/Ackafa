import 'package:ackaf/src/interface/screens/menu/book_hall.dart';
import 'package:flutter/material.dart';

class HallBookingPage extends StatefulWidget {
  const HallBookingPage({super.key});

  @override
  _HallBookingPageState createState() => _HallBookingPageState();
}

class _HallBookingPageState extends State<HallBookingPage> {
  int selectedTab = 0; // 0 for Ongoing, 1 for Upcoming, 2 for Completed

  @override
  Widget build(BuildContext context) {
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

            // Tab Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('ONGOING', 0),
                _buildTabButton('UPCOMING', 1),
                _buildTabButton('COMPLETED', 2),
              ],
            ),
            const SizedBox(height: 16.0),

            // Booking Cards
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Example count
                itemBuilder: (context, index) {
                  return _buildBookingCard("ONGOING");
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

  // Build Tab Button
  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: selectedTab == index ? Colors.red[50] : Colors.transparent,
          border: Border.all(
            color: selectedTab == index ? Colors.red : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedTab == index ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }

  // Build Booking Card
  Widget _buildBookingCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.event, color: Colors.red),
            ),
            const SizedBox(width: 16.0),

            // Hall Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hall Name',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('22.03.2023'),
                  Text('09:30 AM - 10:30 AM'),
                ],
              ),
            ),

            // Status Badge
            Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: const Text(
                'Ongoing',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
