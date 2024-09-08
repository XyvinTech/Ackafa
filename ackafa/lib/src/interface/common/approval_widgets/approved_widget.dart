
import 'package:flutter/material.dart';

class ApprovedWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String college;
  final String batch;

  const ApprovedWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.college,
    required this.batch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            radius: 20.0, // Adjust the size
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                college,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.0,
                ),
              ),
              Text(
                batch,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios)),
    );
  }
}
