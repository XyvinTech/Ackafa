import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/services/api_routes/events_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/interface/screens/event_news/viewmore_event.dart'; // Import the ViewMoreEventPage

class EventPage extends StatelessWidget {
  final List<Event> events;
  const EventPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search for Events',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return _buildPost(
              withImage: true,
              context: context,
              event: events[
                  index], // Assuming your _buildPost takes an event parameter
            );
          },
        ),
      ],
    );
  }

  Widget _buildPost(
      {bool withImage = false,
      required BuildContext context,
      required Event event}) {
    String time = DateFormat('hh:mm a').format(event.date!);
    String date = DateFormat('yyyy-MM-dd').format(event.date!);
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (withImage) ...[
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: Stack(
                    children: [
                      // Image goes here
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                  fit: BoxFit.cover,
                                  'https://placehold.co/600x400/png');
                            },
                            event.image!, // Replace with your image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Icon placed above the image
                      Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(
                            0xFFA9F3C7), // Greenish background for LIVE label
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: event.activate!
                          ? const Text(
                              'LIVE',
                              style: TextStyle(
                                color:
                                    Color(0xFF0F7036), // Darker green for text
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null),
                ),
              ],
            ),
            Container(color: Colors.white, height: 16),
          ],
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.type!,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFFF3F0A9), // Light red background color for date
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 20, color: Color(0xFF700F0F)),
                                const SizedBox(width: 5),
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 109, 84, 84),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFAED0E9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 20, color: Color(0xFF0E1877)),
                                const SizedBox(width: 5),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0E1877),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.name!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. '
                    'Amet hac bibendum dignissim eget pretium turpis in non cum.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewMoreEventPage(
                                    event: event,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF004797), // Blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View more',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
