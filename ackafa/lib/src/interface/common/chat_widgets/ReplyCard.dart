import 'package:ackaf/src/data/models/msg_model.dart';
import 'package:flutter/material.dart';


class ReplyCard extends StatelessWidget {
  const ReplyCard({
    Key? key,
    required this.message,
    required this.time,
    this.feed,
  }) : super(key: key);

  final String message;
  final String time;
  final ChatFeed? feed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2), // Light color for reply message
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (feed?.media != null)
                  GestureDetector( onTap: () {
                    Navigator.pushNamed(context, '/my_posts');
                  },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        feed!.media!,
                        height: 160, // Adjusted height to fit better
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.blue[300],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
