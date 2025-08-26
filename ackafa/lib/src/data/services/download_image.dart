import 'dart:typed_data';

import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

Future<void> downloadImage(String imageUrl,BuildContext context) async {
  try {
    final response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
      name: 'image_${DateTime.now().millisecondsSinceEpoch}',
    );

    CustomSnackbar.showSnackbar(context,'Image saved to gallery');
  } catch (e) {

    CustomSnackbar.showSnackbar(context,'Failed to download image');
  }
}
