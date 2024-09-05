import 'package:ackaf/src/data/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';

class ViewMoreEventPage extends StatelessWidget {
  final Event event;
  const ViewMoreEventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('hh:mm a').format(event.startTime!);
    String date = DateFormat('yyyy-MM-dd').format(event.startDate!);
    bool registered= event.rsvp?.contains(id)?? false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Event Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder with LIVE text
                Stack(
                  children: [
                    Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
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
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFE4483E), // Red background color
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: event.status != null && event.status != ''
                            ? Row(
                                children: [
                                  Text(
                                    event.status!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 8,
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Event Title
                Text(
                  event.eventName!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Date and Time
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFFE30613)),
                        SizedBox(width: 8),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Color(0xFFE30613)),
                        SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Color.fromARGB(255, 192, 188, 188)),
                // Event Description
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Nunc vivamus vel aliquet lacinia. '
                  'Ultricies mauris vulputate amet sagittis diam sit neque enim enim.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 24),
                // Speakers Section
                Text(
                  'Speakers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: event.speakers!.length,
                  itemBuilder: (context, index) {
                    return _buildSpeakerCard(
                        event.speakers![index].image,
                        event.speakers![index].name!,
                        event.speakers![index].designation!);
                  },
                ),
                SizedBox(height: 24),
                // Venue Section
                Text(
                  'Venue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Map Placeholder
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5)),
                  height: 200,
                  child: Image.asset(
                    'assets/eventlocation.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                    height: 50), // Add spacing to avoid overlap with the button
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: customButton(
              label: 'REGISTER EVENT',
              onPressed: () {
                ApiRoutes userApi = ApiRoutes();
                userApi.markEventAsRSVP(event.id!);
              },
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerCard(String? imagePath, String name, String role) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.transparent, // Transparent background for the avatar
          child: Image.network(
            imagePath.toString(),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 40);
            },
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          role,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
