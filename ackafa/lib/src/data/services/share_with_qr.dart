import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

Future<void> captureAndShareWidgetScreenshot(BuildContext context) async {
  // Create a GlobalKey to hold the widget's RepaintBoundary
  final boundaryKey = GlobalKey();
  String userId = '';
  // Define the widget to capture
  final widgetToCapture = RepaintBoundary(
    key: boundaryKey,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Consumer(
          builder: (context, ref, child) {
            final asyncUser = ref.watch(userProvider);
            return asyncUser.when(
              data: (user) {
                userId = user.id ?? '';
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double
                                .infinity, // Sets a bounded width constraint
                            child: Column(
                              children: [
                                const SizedBox(height: 100),
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Column(
                                      children: [
                                        user.image != null && user.image != ''
                                            ? CircleAvatar(
                                                radius: 37,
                                                backgroundImage: NetworkImage(
                                                    user.image ?? ''),
                                              )
                                            : Image.asset(
                                                'assets/icons/dummy_person.png'),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      // Use Expanded here to take up remaining space
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${user.name!.first!} ${user.name?.middle ?? ''} ${user.name!.last!}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (user.college != null)
                                            Text(
                                              user.college?.collegeName ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          // if (user.batch != null)
                                          //   Text(
                                          //     '${user.batch ?? ''}',
                                          //     style: const TextStyle(
                                          //       fontSize: 15,
                                          //     ),
                                          //   ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        QrImageView(
                          size: 285,
                          data:
                              'https://admin.akcafconnect.com/user/${user.id}',
                        ),
                        const SizedBox(height: 20),
                        if (user.phone != null)
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(user.phone?.toString() ?? ''),
                            ],
                          ),
                        const SizedBox(height: 10),
                        if (user.email != null)
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(user.email ?? ''),
                            ],
                          ),
                        const SizedBox(height: 10),
                        if (user.address != null)
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  user.address ?? '',
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: LoadingAnimation()),
              error: (error, stackTrace) =>
                  const Center(child: Text('Error Sharing')),
            );
          },
        ),
      ),
    ),
  );

  // Create an OverlayEntry to render the widget
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (_) => Material(
      color: Colors.transparent,
      child: Center(child: widgetToCapture),
    ),
  );

  // Add the widget to the overlay
  overlay.insert(overlayEntry);

  // Allow time for rendering
  await Future.delayed(const Duration(milliseconds: 500));

  // Capture the screenshot
  final boundary =
      boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    overlayEntry.remove(); // Clean up the overlay
    return;
  }

  // Convert to image
  final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  overlayEntry.remove(); // Clean up the overlay

  if (byteData == null) return;

  final Uint8List pngBytes = byteData.buffer.asUint8List();

  // Save the image as a temporary file
  final tempDir = await getTemporaryDirectory();
  final file =
      await File('${tempDir.path}/screenshot.png').writeAsBytes(pngBytes);

  // Share the screenshot
  Share.shareXFiles(
    [XFile(file.path)],
    text:
        'Check out my profile on AKCAF!:\n https://admin.akcafconnect.com/user/${userId}',
  );
}
