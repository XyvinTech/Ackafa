import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minio_flutter/io.dart';
import 'package:minio_flutter/minio.dart';
import 'package:path/path.dart';

Future<String> imageUpload(String imageName, String imagePath) async {
  Minio.init(
    endPoint: 's3.amazonaws.com',
    accessKey: dotenv.env['AWS_ACCESS_KEY_ID']!,
    secretKey: dotenv.env['AWS_SECRET_ACCESS_KEY']!,
    region: 'ap-south-1',
  );
  await Minio.shared.fPutObject('akcaf-bucket', basename(imageName), imagePath);
  final imageUrl =
      "https://akcaf-bucket.s3.ap-south-1.amazonaws.com/${basename(imagePath)}";
  return imageUrl ?? '';
}
