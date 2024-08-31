import 'package:flutter/material.dart';

class MyPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            
            PostCard(
              imageUrl:
                  'https://via.placeholder.com/400x200', // Replace with your image URL
              content:
                  'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. Amet hac bibendum dignissim eget pretium turpis in non cum.',
              messages: 3,
              dateTime: '12:30 PM - Apr 21, 2021',
            ),
            SizedBox(height: 16),
            PostCard(
              imageUrl:
                  'https://via.placeholder.com/400x200', // Replace with your image URL
              content:
                  'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. Amet hac bibendum dignissim eget pretium turpis in non cum.',
              messages: 4,
              dateTime: '12:30 PM - Apr 21, 2021',
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String imageUrl;
  final String content;
  final int messages;
  final String dateTime;

  PostCard({
    required this.imageUrl,
    required this.content,
    required this.messages,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Handle message tap
              },
              child: Text(
                '$messages messages',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              dateTime,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle delete action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: Text(
                  'DELETE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
