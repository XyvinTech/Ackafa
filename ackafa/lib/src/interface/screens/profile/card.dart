import 'dart:developer';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/save_qr.dart';
import 'package:ackaf/src/data/services/share_qr.dart';
import 'package:ackaf/src/data/services/share_with_qr.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();
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
                            'assets/icons/ackaf_logo.png',
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
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Profile',
                                    style: TextStyle(fontSize: 16),
                                  )
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
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/profile_background2.png'),
                alignment: Alignment.topCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
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
                                    ref
                                        .read(isFullScreenProvider.notifier)
                                        .state = true;
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.close_fullscreen),
                                  onPressed: () {
                                    SystemChrome.setEnabledSystemUIMode(
                                        SystemUiMode.edgeToEdge);
                                    ref
                                        .read(isFullScreenProvider.notifier)
                                        .state = false;
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Screenshot(
                        controller: screenshotController,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Column(
                                  children: [
                                    // Profile Image with Red Border
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: user.image != null &&
                                                user.image != ''
                                            ? Image.network(
                                                user.image ?? '',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/icons/dummy_person_large.png',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      user.fullName ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      user.company?.designation ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      user.company?.name ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // QR Code Section
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF5EA),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: QrImageView(
                                  size: 250,
                                  data:
                                      'https://admin.akcafconnect.com/user/${user.id}',
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Contact Information
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    if (user.phone != null)
                                      _buildContactRow(
                                        Icons.phone,
                                        user.phone?.toString() ?? '',
                                      ),
                                    const SizedBox(height: 15),
                                    if (user.email != null)
                                      _buildContactRow(
                                        Icons.email,
                                        user.email ?? '',
                                      ),
                                    const SizedBox(height: 15),
                                    if (user.address != null)
                                      _buildContactRow(
                                        Icons.location_on,
                                        user.address ?? '',
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      if (!isFullScreen)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: customButton(
                                        buttonHeight: 60,
                                        fontSize: 16,
                                        label: 'SHARE',
                                        onPressed: () async {
                                          captureAndShareWidgetScreenshot(
                                              context);
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: customButton(
                                        sideColor: const Color.fromARGB(
                                            255, 219, 217, 217),
                                        labelColor: const Color(0xFF2C2829),
                                        buttonColor: const Color.fromARGB(
                                            255, 222, 218, 218),
                                        buttonHeight: 60,
                                        fontSize: 13,
                                        label: 'DOWNLOAD QR',
                                        onPressed: () async {
                                          saveQr(
                                              screenshotController:
                                                  screenshotController,
                                              context: context);
                                        }),
                                  ),
                                ],
                              )),
                        ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.red, size: 22),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
