import 'dart:io';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/services/api_routes/image_upload.dart';
import 'package:http/http.dart' as http;

Future<String> uploadFile(String filePath) async {
  final file = File(filePath);

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/upload'),
  );

  request.files.add(await http.MultipartFile.fromPath('image', file.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    return extractImageUrl(responseBody);
  } else {
    throw Exception('Failed to upload file');
  }
}
