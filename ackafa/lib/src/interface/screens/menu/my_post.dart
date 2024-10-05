import 'package:ackaf/src/data/notifires/feed_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/feed_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/loading.dart';

class MyPostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncMyPosts = ref.watch(fetchMyPostsProvider);
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                'My Posts',
                style: TextStyle(fontSize: 17),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // actions: [
              //   IconButton(
              //     icon: FaIcon(FontAwesomeIcons.whatsapp),
              //     onPressed: () {
              //       // WhatsApp action
              //     },
              //   ),
              // ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: Colors.grey,
                  height: 1.0,
                ),
              ),
            ),
            body: asyncMyPosts.when(
              loading: () => Center(child: LoadingAnimation()),
              error: (error, stackTrace) {
                // Handle error state
                return Center(
                  child: Text('USER HASN\'T POSTED ANYTHING'),
                );
              },
              data: (myPosts) {
                print(myPosts);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: myPosts.length,
                          itemBuilder: (context, index) {
                            return _buildPostCard(
                                context,
                                myPosts[index].status ?? '',
                                myPosts[index].content ?? '',
                                '3 messages',
                                myPosts[index].createdAt!,
                                myPosts[index].id!,
                                imageUrl: myPosts[index].media);
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }

  Widget _buildPostCard(BuildContext context, String status, String description,
      String messages, DateTime timestamp, String requirementId,
      {String? imageUrl}) {
    DateTime localDateTime = timestamp.toLocal();

    String formattedDate =
        DateFormat('h:mm a · MMM d, y').format(localDateTime);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color.fromARGB(255, 226, 221, 221))),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != "")
              Column(
                children: [
                  Image.network(imageUrl!),
                  SizedBox(height: 10),
                ],
              ),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${status.toUpperCase()}',
                  style: TextStyle(
                    color: Color(0xFFE30613),
                  ),
                ),
                Text(
                  formattedDate.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEB5757),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                _showDeleteDialog(context, requirementId, imageUrl!);
              },
              child: const Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, requirementId, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://img.freepik.com/free-photo/question-mark-bubble-speech-sign-symbol-icon-3d-rendering_56104-1950.jpg?t=st=1722584569~exp=1722588169~hmac=4fd202dfa51c41238e3a253545f7aab4bf8f87f64027a5f42e82cd22cd3395f5&w=1380',
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Delete Post?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Are you sure?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text('No', style: TextStyle(color: Color(0xFF0E1877))),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFEB5757)),
                        onPressed: () {
                          ApiRoutes userApi = ApiRoutes();
                          userApi.deletePost(token, requirementId, context);
                          ref.invalidate(fetchMyPostsProvider);
                          Navigator.of(context).pop();
                        },
                        child: Text('Yes, Delete',
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
