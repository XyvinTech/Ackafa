import 'package:ackaf/src/interface/common/approval_widgets/approval_dropdown.dart';
import 'package:flutter/material.dart';

class ApprovalRejectedWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String college;
  final String batch;

  const ApprovalRejectedWidget({
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
            radius: 20.0,
            backgroundColor:
                Colors.transparent, // Optional: Set background color if needed
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 40.0, // Match the CircleAvatar radius
                height: 40.0, // Match the CircleAvatar radius
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(color: Color(0xFFE30613),
                    'assets/icons/dummy_person_small.png',
                    fit: BoxFit.cover,
                    width: 40.0,
                    height: 40.0,
                  );
                },
              ),
            ),
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
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ));
  }
}
