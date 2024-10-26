import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/screens/event_news/viewmore_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget eventWidget({
  bool withImage = false,
  required BuildContext context,
  required Event event,
}) {
  DateTime dateTime = DateTime.parse(event.startTime.toString()).toLocal();
  String formattedTime = DateFormat('hh:mm a').format(dateTime);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12), // Reduced padding
    child: Transform.translate(
      offset: const Offset(0, 6), // Adjusted vertical offset
      child: Container(
        margin: const EdgeInsets.only(
            bottom: 12.0), // Reduced space between containers
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0), // Reduced border radius
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 3, // Slightly smaller shadow blur
            //     offset: const Offset(0, 1), // Reduced shadow offset
            //   ),
            // ],
            border:
                Border.all(color: const Color.fromARGB(255, 226, 222, 222))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (withImage) ...[
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    width: MediaQuery.sizeOf(context).width * .85,
                    height: 190, // Reduced image height
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          );
                        },
                        event.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: event.status == 'completed'
                            ? Color(0xFF434343)
                            : event.status == 'live'
                                ? Color(0xFF2D8D00)
                                : Color(0xFF596AFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          if (event.status == 'completed')
                            SvgPicture.asset(
                              'assets/icons/completed.svg',
                              color: Colors.white,
                            ),
                          if (event.status == 'live')
                            SvgPicture.asset(
                              'assets/icons/live.svg',
                              color: Colors.white,
                            ),
                          if (event.status == 'upcoming')
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                          Text(
                            event.status?.toUpperCase() ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            Container(
              padding: const EdgeInsets.all(8.0), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    event.eventName!,
                    style: const TextStyle(
                      fontSize: 14, // Reduced font size
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Reduced space
                  Text(
                    event.description ?? '',
                    style: const TextStyle(
                      fontSize: 12, // Reduced font size
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6), // Reduced space
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                         
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 12,
                                  color:
                                      Color(0xFF700F0F)), // Reduced icon size
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF700F0F),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 1,
                            height: 14,
                            color: const Color.fromARGB(255, 210, 205, 205),
                          ),
                          const SizedBox(width: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 12,
                                  color:
                                      Color(0xFF0E1877)), // Reduced icon size
                              const SizedBox(width: 4),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF0E1877),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: customButton(
                  buttonHeight: 40,
                  label: 'Know More',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ViewMoreEventPage(
                          event: event,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Slide from right to left
                          const end = Offset.zero;
                          const curve = Curves.fastEaseInToSlowEaseOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    ),
  );
}
