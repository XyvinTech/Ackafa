import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/event_countbutton.dart';
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
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Transform.translate(
      offset: const Offset(0, 6),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color.fromARGB(255, 226, 222, 222)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (withImage) ...[
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    width: MediaQuery.sizeOf(context).width * .95,
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        event.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Image loaded successfully
                          }
                          // While the image is loading, show shimmer effect
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
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                          Text(
                            event.status?.toUpperCase() ?? '',
                            style: const TextStyle(
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          event.eventName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.description ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 160),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              color: Colors.yellow,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 13, color: Color(0xFF700F0F)),
                                    const SizedBox(width: 4),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF700F0F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 1,
                              height: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              color: Colors.blue[200],
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 13, color: Color(0xFF0E1877)),
                                    const SizedBox(width: 4),
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0E1877),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Padding(
            //   padding: const EdgeInsets.only(left: 8.0,bottom: 10),
            //   child: EventCountdownButton(
            //       event: event,
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           PageRouteBuilder(
            //             pageBuilder: (context, animation, secondaryAnimation) =>
            //                 ViewMoreEventPage(event: event),
            //             transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //               const begin = Offset(1.0, 0.0);
            //               const end = Offset.zero;
            //               const curve = Curves.fastEaseInToSlowEaseOut;
              
            //               var tween =
            //                   Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            //               var offsetAnimation = animation.drive(tween);
              
            //               return SlideTransition(
            //                 position: offsetAnimation,
            //                 child: child,
            //               );
            //             },
            //           ),
            //         );
            //       },
            //     ),
            // ),

            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: customButton(
                  buttonHeight: 40,
                  buttonWidth: 180,
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
                          const begin = Offset(1.0, 0.0);
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
