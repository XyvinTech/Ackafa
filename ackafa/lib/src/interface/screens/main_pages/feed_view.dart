import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/notifires/feed_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/interface/common/components/app_bar.dart';
import 'package:ackaf/src/interface/common/components/svg_icon.dart';
import 'package:ackaf/src/interface/common/custom_drop_down_block_report.dart';
import 'package:ackaf/src/interface/common/user_tile.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:ackaf/src/interface/screens/people/chat/chatscreen.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
    final _picker = HLImagePicker();

    try {
      // Open the picker to select an image
      final images = await _picker.openPicker(
        cropping: true, // Enable cropping
        pickerOptions: HLPickerOptions(
          mediaType: MediaType.image, // Ensure we are selecting images
          maxSelectedAssets: 1, // Allow selecting only one image
        ),
        cropOptions: HLCropOptions(
          aspectRatio:
              CropAspectRatio(ratioX: 4, ratioY: 5), // Set 4:5 aspect ratio
          compressQuality: 0.9, // Updated: Use a value between 0.1 and 1.0
          compressFormat: CompressFormat.jpg,
          croppingStyle: CroppingStyle.normal, // Optional, set cropping style
        ),
      );

      if (images.isNotEmpty) {
        final selectedImage = images.first;
        setState(() {
          _feedImage = File(selectedImage.path);
          _feedImageSource = ImageSource.gallery;
        });
        return _feedImage;
      }
    } catch (e) {
      debugPrint("Error picking or cropping the image: $e");
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
        appBar: const CustomAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
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
                      ? const Center(child: Text('No FEEDS'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount:
                              filteredFeeds.length + 2, // +2 for Ad and spacer
                          itemBuilder: (context, index) {
                            if (index == filteredFeeds.length) {
                              return isLoading
                                  ? const ReusableFeedPostSkeleton()
                                  : const SizedBox.shrink();
                            }

                            if (index == filteredFeeds.length + 1) {
                              return const SizedBox(height: 80);
                            }

                            final feed = filteredFeeds[index];
                            if (feed.status == 'published') {
                              return _buildPost(
                                withImage: feed.media != null &&
                                    feed.media!.isNotEmpty,
                                feed: feed,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              right: 30,
              bottom: 30,
              child: GestureDetector(
                onTap: () => _openModalSheet(sheet: 'post'),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFE30613),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => _openModalSheet(sheet: 'post'),
        //   label: const Text(
        //     '',
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   icon: const Icon(
        //     Icons.add,
        //     color: Colors.white,
        //     size: 27,
        //   ),
        //   backgroundColor: const Color(0xFFE30613),
        // ),
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
        selectedColor: const Color(0xFFD3EDCA), // When selected

        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color.fromARGB(255, 214, 210, 210)),
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

        final asyncUser = ref.watch(userProvider);

        var receiver = Participant(
          id: feed.author?.id ?? '',
          name: feed.author?.fullName ?? '',
          image: feed.author?.image ?? '',
        );
        log('receiver:${receiver.id}\n${receiver.image}\n${receiver.name}');

        return asyncUser.when(
          data: (user) {
            var sender = Participant(
                id: user.id, image: user.image, name: user.fullName);
            log('sender:${sender.id}\n${sender.image}\n${sender.name}');

            return ReusableFeedPost(
                withImage: feed.media != null ? true : false,
                feed: feed,
                onLike: () async {
                  await userApi.likeFeed(feed.id!);
                  ref.read(feedNotifierProvider.notifier).refreshFeed();
                },
                onComment: () async {},
                onShare: () {
                  feedModalSheet(
                      context: context,
                      onButtonPressed: () async {},
                      buttonText: 'MESSAGE',
                      feed: feed,
                      receiver: receiver,
                      sender: sender);
                });
          },
          loading: () => const ReusableFeedPostSkeleton(),
          error: (error, stackTrace) {
            return Center(
              child: Text('$error'),
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

  final Function onLike;
  final Function onComment;
  final Function onShare;

  const ReusableFeedPost({
    Key? key,
    required this.feed,
    this.withImage = false,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  _ReusableFeedPostState createState() => _ReusableFeedPostState();
}

class _ReusableFeedPostState extends ConsumerState<ReusableFeedPost>
    with SingleTickerProviderStateMixin {
  FocusNode commentFocusNode = FocusNode();
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
                bottom: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text('Comments'),
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
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
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    child: widget.feed.comments?[index].user
                                                ?.image !=
                                            null
                                        ? Image.network(
                                            fit: BoxFit.fill,
                                            widget.feed.comments![index].user!
                                                .image!)
                                        : const Icon(Icons.person),
                                  ),
                                ),
                                title: Text(widget.feed.comments![index].user !=
                                        null
                                    ? widget.feed.comments![index].user!.name ??
                                        'Unknown User'
                                    : 'Unknown User'),
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: commentFocusNode,
              controller: commentController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          const SizedBox(width: 8),
          CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                if (commentController.text != '') {
                  FocusScope.of(context)
                      .unfocus(); // Ensure the keyboard is dismissed immediately

                  ApiRoutes userApi = ApiRoutes();
                  await userApi.postComment(
                      feedId: widget.feed.id!, comment: commentController.text);
                  await ref.read(feedNotifierProvider.notifier).refreshFeed();
                  commentController.clear();
                  commentFocusNode.unfocus();
                }
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: buildUserInfo(widget.feed),
          ),
          if (widget.withImage)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: _buildPostImage(widget.feed.media!),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(widget.feed.content!,
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                _buildActionButtons(),
                GestureDetector(
                  onTap: () => _openCommentModal(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Text(
                      'View all ${widget.feed.comments?.length ?? 0} comments',
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 14.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 30,
                          height: 30,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Image.network(
                            widget.feed.author?.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                  'assets/icons/dummy_person_small.png');
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openCommentModal(),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            'Add a comment...',
                            style: TextStyle(
                                color: Color.fromARGB(255, 129, 128, 128)),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _openCommentModal(),
                        child: const Row(
                          children: [
                            Text(
                              '❤️',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('🙌'),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.add_circle_outline_sharp,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    '${timeAgo(widget.feed.createdAt!)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            aspectRatio: 4 / 5,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Ensure border radius is applied
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit
                      .cover, // Changed to BoxFit.cover for better rendering inside the border
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image fully loaded
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Shimmer respects border radius
                        child: Container(
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  },
                ),
              ),
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  icon: SvgPicture.asset('assets/icons/comment.svg'),
                  onPressed: _openCommentModal,
                ),
                if (widget.feed.author != id)
                  IconButton(
                    icon: SvgPicture.asset('assets/icons/share.svg'),
                    onPressed: () => widget.onShare(),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                '${widget.feed.likes?.length ?? 0} Likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const Spacer(),
        if (widget.feed.author != id)
          CustomDropDown(
            isBlocked: false,
            feed: widget.feed,
          )
      ],
    );
  }
}

class ReusableFeedPostSkeleton extends StatelessWidget {
  const ReusableFeedPostSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Skeleton
            _buildShimmerContainer(height: 200.0, width: double.infinity),
            const SizedBox(height: 16),
            // Content Text Skeleton
            _buildShimmerContainer(height: 14, width: double.infinity),
            const SizedBox(height: 16),
            // User Info Skeleton
            Row(
              children: [
                // User Avatar
                ClipOval(
                  child: _buildShimmerContainer(height: 30, width: 30),
                ),
                const SizedBox(width: 8),
                // User Info (Name, Company)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerContainer(height: 12, width: 100),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(height: 12, width: 60),
                  ],
                ),
                const Spacer(),
                // Post Date Skeleton
                _buildShimmerContainer(height: 12, width: 80),
              ],
            ),
            const SizedBox(height: 16),
            // Action Buttons Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildShimmerCircle(height: 30, width: 30),
                    const SizedBox(width: 8),
                    _buildShimmerCircle(height: 30, width: 30),
                    const SizedBox(width: 8),
                    _buildShimmerCircle(height: 30, width: 30),
                  ],
                ),
                // Likes Count Skeleton
                _buildShimmerContainer(height: 14, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(
      {required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildShimmerCircle({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
