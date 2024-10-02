import 'dart:developer';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isFullScreenProvider = StateProvider<bool>((ref) => false);

    return Consumer(
      builder: (context, ref, child) {
        final isFullScreen = ref.watch(isFullScreenProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: !isFullScreen
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(
                      65.0), // Adjust the size to fit the border and content
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // AppBar background color
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(
                              255, 231, 226, 226), // Border color
                          width: 1.0, // Border width
                        ),
                      ),
                    ),
                    child: AppBar(
                      toolbarHeight: 45.0,
                      scrolledUnderElevation: 0,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      leadingWidth: 100,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/icons/kssiaLogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MenuPage()), // Navigate to MenuPage
                            );
                          },
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Profile')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          if (!isFullScreen) {
                            return IconButton(
                              icon: const Icon(Icons.open_in_full),
                              onPressed: () {
                                SystemChrome.setEnabledSystemUIMode(
                                    SystemUiMode.immersiveSticky);
                                ref.read(isFullScreenProvider.notifier).state =
                                    true;
                              },
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.close_fullscreen),
                              onPressed: () {
                                SystemChrome.setEnabledSystemUIMode(
                                    SystemUiMode.edgeToEdge);
                                ref.read(isFullScreenProvider.notifier).state =
                                    false;
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 15),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                            user.image ??
                                                'https://placehold.co/600x400',
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${user.name!.first!} ${user.name?.middle ?? ''} ${user.name!.last!}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          child: user.company
                                                                          ?.logo !=
                                                                      null &&
                                                                  user.company
                                                                          ?.logo !=
                                                                      ''
                                                              ? Image.network(
                                                                  user.company!
                                                                      .logo!,
                                                                  height: 33,
                                                                  width: 40,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : const SizedBox())
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (user.company
                                                              ?.designation !=
                                                          null)
                                                        Text(
                                                          user.company
                                                                  ?.designation ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    42,
                                                                    41,
                                                                    41),
                                                          ),
                                                        ),
                                                      if (user.company?.name !=
                                                          null)
                                                        Text(
                                                          user.company?.name ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          QrImageView(
                            size: 300,
                            data:
                                'http://dev-api.akcafconnect.com/user/${user.id}',
                          ),
                          const SizedBox(height: 20),
                          if (user.phone != null)
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Text(user.phone.toString() ?? ''),
                              ],
                            ),
                          const SizedBox(height: 10),
                          if (user.email != null)
                            Row(
                              children: [
                                const Icon(Icons.email,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Text(user.email ?? ''),
                              ],
                            ),
                          const SizedBox(height: 10),
                          if (user.address != null)
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    user.address ?? '',
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  // if (!isFullScreen)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 20),
                  //     child: SizedBox(
                  //         height: 50,
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.max,
                  //           children: [
                  //             Flexible(
                  //               child: customButton(
                  //                   buttonHeight: 60,
                  //                   fontSize: 16,
                  //                   label: 'SHARE',
                  //                   onPressed: () {
                  //                     // screenshotController
                  //                     //     .captureFromWidget(
                  //                     //   QrImageView(
                  //                     //     backgroundColor: Colors.white,
                  //                     //     size: 300,
                  //                     //     data:
                  //                     //         'https://api.kssiathrissur.com/user/${user.id}',
                  //                     //   ),
                  //                     // )
                  //                     //     .then((capturedImage) {
                  //                     //   captureAndShareScreenshot(
                  //                     //       capturedImage);
                  //                     // });
                  //                   }),
                  //             ),
                  //             const SizedBox(
                  //               width: 10,
                  //             ),
                  //             Flexible(
                  //               child: customButton(
                  //                   sideColor: const Color.fromARGB(
                  //                       255, 219, 217, 217),
                  //                   labelColor: const Color(0xFF2C2829),
                  //                   buttonColor: const Color.fromARGB(
                  //                       255, 222, 218, 218),
                  //                   buttonHeight: 60,
                  //                   fontSize: 16,
                  //                   label: 'DOWNLOAD QR',
                  //                   onPressed: () async {
                  //                     await requestStoragePermission();
                  //                     screenshotController
                  //                         .captureFromWidget(
                  //                       QrImageView(
                  //                         backgroundColor: Colors.white,
                  //                         size: 300,
                  //                         data:
                  //                             'https://api.kssiathrissur.com/user/${user.id}',
                  //                       ),
                  //                     )
                  //                         .then((capturedImage) {
                  //                       saveScreenshot(capturedImage, context);
                  //                     });
                  //                   }),
                  //             ),
                  //           ],
                  //         )),
                  //   ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
