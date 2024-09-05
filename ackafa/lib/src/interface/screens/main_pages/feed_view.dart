import 'dart:io';

import 'package:ackaf/src/data/notifires/feed_notifier.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/services/api_routes/feed_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/customModalsheets.dart';
import 'package:ackaf/src/interface/common/loading.dart';

class FeedView extends ConsumerStatefulWidget {
  FeedView({super.key});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  final TextEditingController feedContentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(feedNotifierProvider.notifier).fetchMoreFeed();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(feedNotifierProvider.notifier).fetchMoreFeed();
    }
  }

  File? _feedImage;
  ApiRoutes api = ApiRoutes();

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
      ],
    );

    if (result != null) {
      setState(() {
        _feedImage = File(result.files.single.path!);
      });
      return _feedImage;
    }
    return null;
  }

  void _openModalSheet({required String sheet}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ShowAddPostSheet(
            pickImage: _pickFile,
            textController: feedContentController,
            imageType: sheet,
            postImage: _feedImage,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(feedNotifierProvider);
    final isLoading = ref.read(feedNotifierProvider.notifier).isLoading;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/icons/ackaf_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              size: 21,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.menu,
              size: 21,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage()), // Navigate to MenuPage
              );
            },
          ),
        ],
      ),
      body: feeds.isEmpty
          ? Center(
              child: Text('No FEEDS'),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search your requirements',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 211, 211),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 211, 211),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 211, 211),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: 16),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: feeds.length + 1, // Ad
                  itemBuilder: (context, index) {
                    if (index == feeds.length) {
                      return isLoading
                          ? Center(
                              child:
                                  LoadingAnimation()) // Show loading when fetching more users
                          : SizedBox.shrink(); // Hide when done
                    }

                    final feed = feeds[index];
                       if (feed.status == 'published') {
                        return _buildPost(
                          withImage:
                              feed.media != null && feed.media!.isNotEmpty,
                          feed: feed,
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                  },
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openModalSheet(sheet: 'post'),
        label: const Text(
          'Add Post',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),
        backgroundColor: Color(0xFFE30613),
      ),
    );
  }

  Widget _buildPost({bool withImage = false, required Feed feed}) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(fetchUserByIdProvider(feed.author!));
        return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: asyncUser.when(
              loading: () => Center(child: LoadingAnimation()),
              error: (error, stackTrace) {
                // Handle error state
                return Center(
                  child: Text('Error loading promotions: $error'),
                );
              },
              data: (user) {
                print(user);
                if (feed.author != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (withImage) ...[
                          SizedBox(height: 16),
                          Container(
                            height: 200,
                            width: double.infinity,
                            child: Image.network(
                              fit: BoxFit.cover,
                              feed.media ?? 'https://placehold.co/600x400',
                            ),
                          )
                        ],
                        SizedBox(height: 16),
                        Text(
                          feed.content!,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 30,
                                height: 30,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Image.network(
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.person);
                                  },
                                  user.image!, // Replace with your image URL
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.name?.first} ${user.name?.middle} ${user.name?.last}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                if (user.company?.name != null)
                                  Text(
                                    user.company!.name!,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              feed.createdAt.toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No requirements'),
                  );
                }
              },
            ));
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  final String authorName;
  final String companyName;
  final String timestamp;
  final String content;
  final String imagePath;

  PostWidget({
    required this.authorName,
    required this.companyName,
    required this.timestamp,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Image(image: NetworkImage(imagePath)),
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/avatar.png'), // Replace with your avatar image path
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(companyName),
                ],
              ),
              Spacer(),
              Text(timestamp),
            ],
          ),
        ],
      ),
    );
  }
}
