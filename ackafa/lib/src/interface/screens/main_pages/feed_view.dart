import 'dart:io';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/notifires/feed_notifier.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/services/api_routes/feed_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/customModalsheets.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                        withImage: feed.media != null && feed.media!.isNotEmpty,
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
        return asyncUser.when(
          data: (user) {
            return ReusableFeedPost(
                withImage: feed.media != null ? true : false,
                feed: feed,
                user: user,
                onLike: () {},
                onComment: () {},
                onShare: () {});
          },
          loading: () => Center(child: LoadingAnimation()),
          error: (error, stackTrace) {
            return Center(
              child: Text('Error loading promotions: $error'),
            );
          },
        );
      },
    );
  }
}

class ReusableFeedPost extends StatefulWidget {
  final Feed feed;
  final bool withImage;
  final UserModel user;
  final Function onLike;
  final Function onComment;
  final Function onShare;

  const ReusableFeedPost({
    Key? key,
    required this.feed,
    this.withImage = false,
    required this.user,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  _ReusableFeedPostState createState() => _ReusableFeedPostState();
}

class _ReusableFeedPostState extends State<ReusableFeedPost>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  bool showHeartAnimation = false;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      showHeartAnimation = true;
      widget.onLike(); // Call external like handler
    });
    _animationController.forward().then((_) {
      _animationController.reset();
      setState(() {
        showHeartAnimation = false;
      });
    });
  }

  void _openCommentModal() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7, // Adjust height
            child: Scaffold(
              appBar: AppBar(
                title: Text('Comments'),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10, // Example comments count
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.person),
                          ),
                          title: Text('User $index'),
                          subtitle: Text('This is a comment $index.'),
                        );
                      },
                    ),
                  ),
                  _buildCommentInputField(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                hintText: "Add a comment...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('Post'),
            onPressed: () {
              // Handle posting comment
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.withImage) _buildPostImage(),
            SizedBox(height: 16),
            Text(widget.feed.content!, style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),
            _buildUserInfo(widget.user),
            SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: Image.network(
              widget.feed.media ?? 'https://placehold.co/600x400',
              fit: BoxFit.cover,
            ),
          ),
          if (showHeartAnimation)
            Icon(Icons.favorite, color: Colors.red.withOpacity(0.8), size: 100)
                .animate(target: showHeartAnimation ? 1 : 0)
                .scaleXY(begin: 0.7, end: 1.2)
                .then()
                .scaleXY(begin: 1.2, end: 0.9),
        ],
      ),
    );
  }

  Widget _buildUserInfo(UserModel user) {
    return Row(
      children: [
        ClipOval(
          child: Container(
            width: 30,
            height: 30,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Image.network(
              user.image!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person);
              },
            ),
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${user.name?.first} ${user.name?.middle} ${user.name?.last}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            if (user.company?.name != null)
              Text(
                user.company!.name!,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
        Spacer(),
        Text(
          widget.feed.createdAt.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.black,
              ),
              onPressed: _toggleLike,
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.comment),
              onPressed: _openCommentModal,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () => widget.onShare(), // External share handler
            ),
          ],
        ),
        Text('10 Likes')
      ],
    );
  }
}
