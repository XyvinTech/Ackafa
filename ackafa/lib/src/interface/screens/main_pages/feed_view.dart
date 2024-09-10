import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/notifires/feed_notifier.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  ImageSource? _feedImageSource;
  ApiRoutes api = ApiRoutes();

  Future<File?> _pickFile({required String imageType}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _feedImage = File(image.path);
        _feedImageSource = ImageSource.gallery;
      });
      return _feedImage;
    }
    return null;
  }

  void _openModalSheet({required String sheet}) {
    feedContentController.clear();
    _feedImage = null;
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

  String selectedFilter = 'All'; // Default filter is 'All'

  // Example method to filter feeds
  List<Feed> filterFeeds(List<Feed> feeds) {
    if (selectedFilter == 'All') {
      return feeds;
    } else {
      return feeds.where((feed) => feed.type == selectedFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(feedNotifierProvider);
    final isLoading = ref.read(feedNotifierProvider.notifier).isLoading;

    List<Feed> filteredFeeds = filterFeeds(feeds);

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.red,
      onRefresh: () => ref.read(feedNotifierProvider.notifier).refreshFeed(),
      child: Scaffold(
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
        body: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Material(
                elevation: 2.0, // Adjust elevation to control shadow depth
                shadowColor:
                    Colors.black.withOpacity(0.25), // Shadow color with opacity
                borderRadius: BorderRadius.circular(
                    8.0), // Same border radius as TextField
                child: TextField(
                  decoration: InputDecoration(
                    filled: true, // Ensures the background is fully white
                    fillColor:
                        Colors.white, // Background color inside TextField
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search Feed',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 215, 212, 212)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 215, 212, 212)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 215, 212, 212)),
                    ),
                  ),
                ),
              ),
            ),
            // Horizontally scrollable Choice Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildChoiceChip('All'),
                    _buildChoiceChip('Information'),
                    _buildChoiceChip('Job'),
                    _buildChoiceChip('Funding'),
                    _buildChoiceChip('Requirement'),
                  ],
                ),
              ),
            ),
            // Feed list
            Expanded(
              child: filteredFeeds.isEmpty
                  ? Center(child: Text('No FEEDS'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredFeeds.length + 1, // Ad
                      itemBuilder: (context, index) {
                        if (index == filteredFeeds.length) {
                          return isLoading
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox.shrink();
                        }

                        final feed = filteredFeeds[index];
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
            ),
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
      ),
    );
  }

  // Method to build individual Choice Chips
  Widget _buildChoiceChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == label,
        onSelected: (selected) {
          setState(() {
            selectedFilter = label;
          });
        },
        backgroundColor: Colors.white, // Light green background color
        selectedColor: Color(0xFFD3EDCA), // When selected

        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(255, 214, 210, 210)),
          borderRadius: BorderRadius.circular(20.0), // Circular border
        ),
        showCheckmark: false, // Remove tick icon
      ),
    );
  }

  Widget _buildPost({bool withImage = false, required Feed feed}) {
    return Consumer(
      builder: (context, ref, child) {
        ApiRoutes userApi = ApiRoutes();
        final asyncUser = ref.watch(fetchUserByIdProvider(feed.author!));
        return asyncUser.when(
          data: (user) {
            return ReusableFeedPost(
                withImage: feed.media != null ? true : false,
                feed: feed,
                user: user,
                onLike: () async {
                  await userApi.likeFeed(feed.id!);
                  ref.read(feedNotifierProvider.notifier).refreshFeed();
                },
                onComment: () async {},
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

class ReusableFeedPost extends ConsumerStatefulWidget {
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

class _ReusableFeedPostState extends ConsumerState<ReusableFeedPost>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  bool showHeartAnimation = false;
  late AnimationController _animationController;
  TextEditingController commentController = TextEditingController();
  int likes = 0;
  @override
  void initState() {
    super.initState();

    initialize();
  }

  initialize() async {
    if (widget.feed.likes!.contains(id)) {
      isLiked = true;
    }
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _toggleLike() {
    setState(() {
      likes = isLiked == true ? likes - 1 : likes + 1;
      isLiked = !isLiked;
      showHeartAnimation = true;
      widget.onLike();
    });
    _animationController.forward().then((_) {
      _animationController.reset();
      setState(() {
        showHeartAnimation = false;
      });
    });
  }

  void _openCommentModal() {
    log('comments: ${widget.feed.comments?.length}');
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
                      itemCount: widget.feed.comments?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Consumer(
                          builder: (context, ref, child) {
                            return ListTile(
                              leading: ClipOval(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: widget.feed.comments?[index].user
                                              ?.image !=
                                          null
                                      ? Image.network(
                                          fit: BoxFit.fill,
                                          widget.feed.comments![index].user!
                                              .image!)
                                      : Icon(Icons.person),
                                ),
                              ),
                              title: Text(
                                  widget.feed.comments![index].user != null
                                      ? widget.feed.comments![index].user!.name
                                              ?.first ??
                                          'Unkown User'
                                      : 'Unkown User'),
                              subtitle: Text(
                                  widget.feed.comments?[index].comment ?? ''),
                            );
                          },
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
              controller: commentController,
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
            child: Text(
              'Post',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              if (commentController.text != '') {
                ApiRoutes userApi = ApiRoutes();
                await userApi.postComment(
                    feedId: widget.feed.id!, comment: commentController.text);
                await ref.read(feedNotifierProvider.notifier).refreshFeed();
                commentController.clear();
                Navigator.pop(context);
              }
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
            if (widget.withImage) _buildPostImage(widget.feed.media!),
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

  Widget _buildPostImage(String imageUrl) {
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 4 / 4,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
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
    String formattedDateTime = DateFormat('h:mm a · MMM d, yyyy')
        .format(DateTime.parse(widget.feed.updatedAt.toString()).toLocal());
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
          formattedDateTime,
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
        Text('${widget.feed.likes?.length ?? 0} Likes')
      ],
    );
  }
}
