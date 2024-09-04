import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/services/api_routes/notification_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/interface/common/loading.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onWillPop: () async {
      //   return true;
      // },
      child: Consumer(
        builder: (context, ref, child) {
          final asyncUnreadNotification =
              ref.watch(fetchUnreadNotificationsProvider(token));
          final asyncreadNotification =
              ref.watch(fetchreadNotificationsProvider(token));
          return Scaffold(
            appBar: AppBar(
              title: Text('Notifications'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // asyncUnreadNotification.when(
                  //   data: (unreadNotifications) {
                  //     return ListView.builder(
                  //       shrinkWrap: true, // Added this line
                  //       physics:
                  //           NeverScrollableScrollPhysics(), // Prevents scrolling within the ListView
                  //       itemCount: unreadNotifications.length,
                  //       itemBuilder: (context, index) {
                  //         bool readed = false;
                  //         return _buildNotificationCard(
                  //           readed: readed,
                  //           subject: unreadNotifications[index].subject!,
                  //           content: unreadNotifications[index].content!,
                  //           dateTime: unreadNotifications[index].updatedAt!,
                  //         );
                  //       },
                  //       padding: EdgeInsets.all(0.0),
                  //     );
                  //   },
                  //   loading: () => Center(child: LoadingAnimation()),
                  //   error: (error, stackTrace) {
                  //     return Center(
                  //       child: Text('Error loading promotions: $error'),
                  //     );
                  //   },
                  // ),
                  // asyncreadNotification.when(
                  //   data: (readNotifications) {
                  //     return ListView.builder(
                  //       shrinkWrap: true, // Added this line
                  //       physics:
                  //           NeverScrollableScrollPhysics(), // Prevents scrolling within the ListView
                  //       itemCount: readNotifications.length,
                  //       itemBuilder: (context, index) {
                  //         bool readed = true;
                  //         return _buildNotificationCard(
                  //           readed: readed,
                  //           subject: readNotifications[index].subject!,
                  //           content: readNotifications[index].content!,
                  //           dateTime: readNotifications[index].updatedAt!,
                  //         );
                  //       },
                  //       padding: EdgeInsets.all(0.0),
                  //     );
                  //   },
                  //   loading: () => Center(child: LoadingAnimation()),
                  //   error: (error, stackTrace) {
                  //     return Center(
                  //       child: Text('Error loading promotions: $error'),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
      {required bool readed,
      required String subject,
      required String content,
      required DateTime dateTime}) {
    String time = timeAgo(dateTime);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: Card(
        elevation: 1,
        color: readed ? Color(0xFFF2F2F2) : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!readed) Icon(Icons.circle, color: Colors.blue, size: 12),
                  SizedBox(width: 8),
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String timeAgo(DateTime pastDate) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(pastDate);

  // Get the number of days, hours, and minutes
  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;

  // Generate a human-readable string based on the largest unit
  if (days > 0) {
    return '$days day${days > 1 ? 's' : ''} ago';
  } else if (hours > 0) {
    return '$hours hour${hours > 1 ? 's' : ''} ago';
  } else if (minutes > 0) {
    return '$minutes minute${minutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
