import 'dart:developer';
import 'dart:typed_data';

import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
Future<void> saveQr({
  required ScreenshotController screenshotController,
  required BuildContext context
}) async {
     

    screenshotController.capture().then((Uint8List? image) async {

      log('capture  image$image');
      if (image != null) {
        // Save the screenshot to the gallery
        final result = await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(image),
          quality: 100,
          name: "HEF${DateTime.now().millisecondsSinceEpoch}",
        );
        print(result); // You can check the result if needed
  CustomSnackbar.showSnackbar(context, 'Downloaded to gallery!');
      }
    }).catchError((onError) {
      print(onError);
 CustomSnackbar.showSnackbar(context, 'Error Saving to gallery!');
    });
 
}
