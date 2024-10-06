import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildUserInfo(UserModel user, Feed feed) {
  String formattedDateTime = DateFormat('h:mm a · MMM d, yyyy')
      .format(DateTime.parse(feed.createdAt.toString()).toLocal());
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          ClipOval(
            child: Container(
              width: 30,
              height: 30,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Image.network(
                user.image ?? 'https://placehold.co/600x400',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    
                      'assets/icons/dummy_person_small.png');
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.name?.first} ${user.name?.middle ?? ''} ${user.name?.last}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              if (user.company?.name != null)
                Text(
                  user.company!.name!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
      const SizedBox(width: 8),
      Flexible(
        flex: 1, // Allow date text to wrap if needed
        fit: FlexFit.loose,
        child: Text(
          formattedDateTime,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    ],
  );
}
