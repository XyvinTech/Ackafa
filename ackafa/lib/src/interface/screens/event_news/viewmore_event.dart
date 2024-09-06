import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/services/api_routes/events_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    bool registered = event.rsvp?.contains(id) ?? false;
    log('event registered?:$registered');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Event Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: Image.network(
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                              fit: BoxFit.fill,
                              'https://placehold.co/600x400/png');
                        },
                        event.image!, // Replace with your image URL
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFE4483E), // Red background color
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: event.status != null && event.status != ''
                            ? Row(
                                children: [
                                  Text(
                                    event.status!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
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
                const SizedBox(height: 16),
                // Event Title
                Text(
                  event.eventName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Date and Time
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Color(0xFFE30613)),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFFE30613)),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color.fromARGB(255, 192, 188, 188)),
                const Text('Organiser'),
                Text(
                  event.organiser ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Lorem ipsum dolor sit amet consectetur. Nunc vivamus vel aliquet lacinia. '
                  'Ultricies mauris vulputate amet sagittis diam sit neque enim enim.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                // Speakers Section
                const Text(
                  'Speakers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: event.speakers!.length,
                  itemBuilder: (context, index) {
                    return _buildSpeakerCard(
                        event.speakers![index].image,
                        event.speakers![index].name!,
                        event.speakers![index].designation!);
                  },
                ),
                const SizedBox(height: 24),
                // Venue Section
                const Text(
                  'Venue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(
                    height: 50), // Add spacing to avoid overlap with the button
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: customButton(
                  label: event.status == 'cancelled'
                      ? 'CANCELLED'
                      : registered
                          ? 'ALREADY REGISTERED'
                          : 'REGISTER EVENT',
                  onPressed: () {
                    if (!registered && event.status != 'cancelled') {
                      ApiRoutes userApi = ApiRoutes();
                      userApi.markEventAsRSVP(event.id!);
                      ref.invalidate(fetchEventsProvider);
                    }
                  },
                  fontSize: 16,
                ),
              );
            },
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
              return const Icon(Icons.person, size: 40);
            },
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          role,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
