import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/event_countbutton.dart';
import 'package:ackaf/src/interface/constants/text_style.dart';
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
  // DateTime dateTime = DateTime.parse(event.startTime.toString()).toLocal();
  // String formattedTime = DateFormat('hh:mm a').format(dateTime);
  // String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  String time = DateFormat('hh:mm a').format(event.startTime!);
  String date = DateFormat('yyyy-MM-dd').format(event.startDate!);

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
                  SizedBox(
                    height: 7,
                  ),
                  //date and time
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                      // Text('TOPIC',style: AppTextStyles.subHeading12,),



                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Flexible(
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           color: Colors.yellow,
                      //           borderRadius: BorderRadius.circular(4),
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 6, vertical: 3),
                      //         child: Row(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             const Icon(Icons.calendar_today,
                      //                 size: 13, color: Color(0xFF700F0F)),
                      //             const SizedBox(width: 4),
                      //             Flexible(
                      //               child: Text(
                      //                 formattedDate,
                      //                 style: const TextStyle(
                      //                   fontSize: 12,
                      //                   color: Color(0xFF700F0F),
                      //                 ),
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     Flexible(
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           color: Colors.blueAccent.withOpacity(0.2),
                      //           borderRadius: BorderRadius.circular(4),
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 6, vertical: 3),
                      //         child: Row(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             const Icon(Icons.access_time,
                      //                 size: 13, color: Color(0xFF0E1877)),
                      //             const SizedBox(width: 4),
                      //             Flexible(
                      //               child: Text(
                      //                 formattedTime,
                      //                 style: const TextStyle(
                      //                   fontSize: 12,
                      //                   color: Color(0xFF0E1877),
                      //                 ),
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),


                    // ],
                  // ),


                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.type!,
                        style: AppTextStyles.subHeading14,
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
                                    size: 13, color: Color(0xFF700F0F)),
                                const SizedBox(width: 5),
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 12,
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
                                    size: 13, color: Color(0xFF0E1877)),
                                const SizedBox(width: 5),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 12,
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
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: customButton(
                  radius: 8,
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
