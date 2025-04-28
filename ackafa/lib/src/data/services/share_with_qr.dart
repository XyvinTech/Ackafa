import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

Future<void> captureAndShareWidgetScreenshot(BuildContext context) async {
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
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
                              SizedBox(
                                height: 60,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                              Container(
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: user.image != null &&
                                                      user.image != ''
                                                  ? Image.network(
                                                      user.image ?? '',
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(   width: 100,
                                                      height: 100,
                                'assets/icons/dummy_person_large.png'),
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
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
                              const SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
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
