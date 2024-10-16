import 'dart:async';
import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/data/models/promotions_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/notifires/approval_notifier.dart';
import 'package:ackaf/src/data/notifires/people_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/events_api.dart';
import 'package:ackaf/src/data/services/api_routes/promotions_api.dart';
import 'package:ackaf/src/data/services/dynamic_links.dart';
import 'package:ackaf/src/interface/common/components/app_bar.dart';
import 'package:ackaf/src/interface/common/custom_video.dart';
import 'package:ackaf/src/interface/common/event_widget.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/event_news/viewmore_event.dart';
import 'package:ackaf/src/interface/screens/main_pages/approvalPages/approval_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerStatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ScrollController _bannerScrollController = ScrollController();
  ScrollController _noticeScrollController = ScrollController();
  ScrollController _posterScrollController = ScrollController();
  ScrollController _eventScrollController = ScrollController();
  PageController _videoCountController = PageController();

  Timer? _bannerScrollTimer;
  Timer? _noticeScrollTimer;
  Timer? _posterScrollTimer;
  Timer? _eventScrollTimer;
  Timer? _restartAutoScrollTimer;
  bool _isUserInteracting = false; // To track user interaction

  int _currentBannerIndex = 0;
  int _currentNoticeIndex = 0;
  int _currentPosterIndex = 0;
  int _currentEventIndex = 0;

  final GlobalKey _bannerKey = GlobalKey();
  final GlobalKey _noticeKey = GlobalKey();
  final GlobalKey _posterKey = GlobalKey();
  final GlobalKey _eventKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchInitialApprovals();
  }

  Future<void> _fetchInitialApprovals() async {
    await ref.read(approvalNotifierProvider.notifier).fetchMoreApprovals();
  }

  double _getItemWidth(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 200.0;
  }

  double _calculateDynamicHeight(List<Promotion> notices) {
    double maxHeight = 0.0;

    for (var notice in notices) {
      // Estimate height based on the length of title and description
      final double titleHeight =
          _estimateTextHeight(notice.title!, 18.0); // Font size 18 for title
      final double descriptionHeight = _estimateTextHeight(
          notice.description!, 14.0); // Font size 14 for description

      final double itemHeight =
          titleHeight + descriptionHeight; // Adding padding
      if (itemHeight > maxHeight) {
        maxHeight = itemHeight + 10;
      }
    }
    return maxHeight;
  }

  double _estimateTextHeight(String text, double fontSize) {
    // Estimate text height based on string length, font size, and max width
    final double screenWidth =
        MediaQuery.sizeOf(context).width; // Adjust based on available space
    final int numLines = (text.length / (screenWidth / fontSize)).ceil();
    return numLines * fontSize * 1.2; // Multiplying by 1.2 for line height
  }

  // Updated auto-scroll start
  void startAutoScroll({
    required ScrollController controller,
    required List<dynamic> items,
    required int currentIndex,
    required GlobalKey itemKey,
    required Function(int) onIndexChanged,
    required Timer? scrollTimer,
    Duration scrollInterval = const Duration(seconds: 5),
  }) {
    // Ensure the timer is cleared before starting a new one
    scrollTimer?.cancel();
    scrollTimer = Timer.periodic(scrollInterval, (timer) {
      if (!_isUserInteracting && mounted) {
        currentIndex++;
        if (currentIndex >= items.length) {
          currentIndex = 0;
        }
        final itemWidth = _getItemWidth(itemKey);
        if (controller.hasClients) {
          controller.animateTo(
            currentIndex * itemWidth,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        if (mounted) {
          setState(() {
            onIndexChanged(currentIndex);
          });
        }
      }
    });
  }

  void stopAutoScroll() {
    _bannerScrollTimer?.cancel();
    _noticeScrollTimer?.cancel();
    _posterScrollTimer?.cancel();
    _eventScrollTimer?.cancel();
    _isUserInteracting = true;
  }

  void restartAutoScroll(
      List<dynamic> banners, List<dynamic> notices, List<dynamic> posters) {
    _restartAutoScrollTimer
        ?.cancel(); // Cancel the previous restart timer if any
    _restartAutoScrollTimer = Timer(const Duration(seconds: 7), () {
      _isUserInteracting = false; // Reset the interaction flag

      // Restart auto-scroll for all promotion types
      startAutoScroll(
        controller: _bannerScrollController,
        items: banners,
        currentIndex: _currentBannerIndex,
        itemKey: _bannerKey,
        onIndexChanged: (index) => setState(() {
          _currentBannerIndex = index;
        }),
        scrollTimer: _bannerScrollTimer,
      );
      startAutoScroll(
        controller: _noticeScrollController,
        items: notices,
        currentIndex: _currentNoticeIndex,
        itemKey: _noticeKey,
        onIndexChanged: (index) => setState(() {
          _currentNoticeIndex = index;
        }),
        scrollTimer: _noticeScrollTimer,
      );
      startAutoScroll(
        controller: _posterScrollController,
        items: posters,
        currentIndex: _currentPosterIndex,
        itemKey: _posterKey,
        onIndexChanged: (index) => setState(() {
          _currentPosterIndex = index;
        }),
        scrollTimer: _posterScrollTimer,
      );
    });
  }

  void restartEventAutoScroll(List<dynamic> events) {
    _restartAutoScrollTimer
        ?.cancel(); // Cancel the previous restart timer if any
    _restartAutoScrollTimer = Timer(const Duration(seconds: 7), () {
      _isUserInteracting = false; // Reset the interaction flag

      // Restart auto-scroll for all promotion types
      if (_eventScrollController.hasClients) {
        startAutoScroll(
          controller: _eventScrollController,
          items: events,
          currentIndex: _currentEventIndex,
          itemKey: _bannerKey,
          onIndexChanged: (index) => setState(() {
            _currentEventIndex = index;
          }),
          scrollTimer: _eventScrollTimer,
        );
      }
    });
  }

  void _onUserGestureDetected(
      List<dynamic> banners, List<dynamic> notices, List<dynamic> posters) {
    stopAutoScroll(); // Stop auto-scroll when a gesture is detected
    restartAutoScroll(
      banners,
      notices,
      posters,
    ); // Restart auto-scroll after 10 seconds
  }

  void _onUserEventGestureDetected(List<dynamic> events) {
    stopAutoScroll(); // Stop auto-scroll when a gesture is detected
    restartEventAutoScroll(events); // Restart auto-scroll after 10 seconds
  }

  @override
  void dispose() {
    _bannerScrollTimer?.cancel();
    _noticeScrollTimer?.cancel();
    _posterScrollTimer?.cancel();
    _eventScrollTimer?.cancel();
    _restartAutoScrollTimer?.cancel();

    _bannerScrollController.dispose();
    _noticeScrollController.dispose();
    _posterScrollController.dispose();
    _eventScrollController.dispose();

    super.dispose();
  }

  final ValueNotifier<int> _currentVideo = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    _videoCountController.addListener(() {
      _currentVideo.value = _videoCountController.page!.round();
    });
    return Consumer(
      builder: (context, ref, child) {
        final asyncPromotions = ref.watch(fetchPromotionsProvider(token));
        final nonApprovedUsers = ref.watch(approvalNotifierProvider);
        final asyncEvents = ref.watch(fetchEventsProvider);
        log(nonApprovedUsers.toString());
        return Scaffold(
          backgroundColor: Colors.white,
          body: asyncPromotions.when(
            data: (promotions) {
              final banners =
                  promotions.where((promo) => promo.type == 'banner').toList();
              final posters =
                  promotions.where((promo) => promo.type == 'poster').toList();
              final notices =
                  promotions.where((promo) => promo.type == 'notice').toList();
              final videos =
                  promotions.where((promo) => promo.type == 'video').toList();
              final filteredVideos = videos
                  .where((video) => video.link!.startsWith('http'))
                  .toList();
              // Start auto-scroll for all promotions when data is ready
              if (banners.isNotEmpty) {
                startAutoScroll(
                  controller: _bannerScrollController,
                  items: banners,
                  currentIndex: _currentBannerIndex,
                  itemKey: _bannerKey,
                  onIndexChanged: (index) => setState(() {
                    _currentBannerIndex = index;
                  }),
                  scrollTimer: _bannerScrollTimer,
                );
              }

              if (notices.isNotEmpty) {
                startAutoScroll(
                  controller: _noticeScrollController,
                  items: notices,
                  currentIndex: _currentNoticeIndex,
                  itemKey: _noticeKey,
                  onIndexChanged: (index) => setState(() {
                    _currentNoticeIndex = index;
                  }),
                  scrollTimer: _noticeScrollTimer,
                );
              }

              if (posters.isNotEmpty) {
                startAutoScroll(
                  controller: _posterScrollController,
                  items: posters,
                  currentIndex: _currentPosterIndex,
                  itemKey: _posterKey,
                  onIndexChanged: (index) => setState(() {
                    _currentPosterIndex = index;
                  }),
                  scrollTimer: _posterScrollTimer,
                );
              }
              asyncEvents.whenData(
                (events) {
                  events = events;
                  if (events.isNotEmpty) {
                    startAutoScroll(
                      controller: _eventScrollController,
                      items: events,
                      currentIndex: _currentEventIndex,
                      itemKey: _eventKey,
                      onIndexChanged: (index) => setState(() {
                        _currentEventIndex = index;
                      }),
                      scrollTimer: _eventScrollTimer,
                    );
                  }
                },
              );
              return GestureDetector(
                onPanDown: (_) =>
                    _onUserGestureDetected(banners, notices, posters),
                onTap: () => _onUserGestureDetected(banners, notices, posters),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(),
                      const SizedBox(
                        height: 20,
                      ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(top: 8, left: 8, right: 8),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //       prefixIcon: const Icon(Icons.search),
                      //       hintText: 'Search promotions',
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide: const BorderSide(
                      //             color: Color.fromARGB(255, 214, 211, 211)),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide: const BorderSide(
                      //             color: Color.fromARGB(255, 217, 212, 212)),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      if (widget.user.role != 'member')
                        Consumer(
                          builder: (context, ref, child) {
                            if (nonApprovedUsers.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFFFE0E2), // Background color
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 222, 178, 181),
                                          width: 1,
                                          strokeAlign:
                                              BorderSide.strokeAlignInside)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Approvals Pending',
                                            style: TextStyle(
                                              color: Color(
                                                  0xFFE30613), // Text color
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.white,
                                            child: Text(
                                              nonApprovedUsers.length
                                                  .toString(),
                                              style: TextStyle(
                                                color: Color(
                                                    0xFFE30613), // Text color for number
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                ApprovalPage(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(1.0,
                                                  0.0); // Slide from right to left
                                              const end = Offset.zero;
                                              const curve = Curves
                                                  .fastEaseInToSlowEaseOut;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              var offsetAnimation =
                                                  animation.drive(tween);

                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                          color:
                                              Color(0xFFE30613), // Arrow color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      if (banners.isNotEmpty)
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            color: Colors.transparent,
                            height: 175,
                            child: ListView.builder(
                              key: _bannerKey,
                              controller: _bannerScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: banners.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: _buildBanners(
                                      context: context, banner: banners[index]),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (notices.isNotEmpty)
                        SizedBox(
                          height: _calculateDynamicHeight(notices),
                          child: ListView.builder(
                            key: _noticeKey,
                            controller: _noticeScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: notices.length,
                            itemBuilder: (context, index) {
                              return customNotice(
                                  context: context, notice: notices[index]);
                            },
                          ),
                        ),

                      Consumer(
                        builder: (context, ref, child) {
                          final asyncEvents = ref.watch(fetchEventsProvider);
                          return asyncEvents.when(
                            data: (events) {
                              return Column(
                                children: [
                                  if (events.isNotEmpty)
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, top: 10),
                                          child: Text(
                                            'Events',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  GestureDetector(
                                      onPanDown: (_) =>
                                          _onUserEventGestureDetected(events),
                                      onTap: () =>
                                          _onUserEventGestureDetected(events),
                                      child: SizedBox(
                                        height:
                                            320, // Limit the total height for the ListView
                                        child: ListView.builder(
                                          key: _eventKey,
                                          controller: _eventScrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: events.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewMoreEventPage(
                                                            event:
                                                                events[index]),
                                                  ),
                                                );
                                                ref.invalidate(
                                                    fetchEventsProvider);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85, // Adjust width to fit horizontally
                                                child: eventWidget(
                                                  withImage: true,
                                                  context: context,
                                                  event: events[index],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                ],
                              );
                            },
                            loading: () => Center(child: LoadingAnimation()),
                            error: (error, stackTrace) {
                              return SizedBox();
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      if (posters.isNotEmpty)
                        SizedBox(
                          height: 380,
                          child: ListView.builder(
                            key: _posterKey,
                            controller: _posterScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: posters.length,
                            itemBuilder: (context, index) {
                              return customPoster(
                                  context: context, poster: posters[index]);
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (filteredVideos.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(
                              height: 265,
                              child: ListView.builder(
                                controller: _videoCountController,
                                scrollDirection: Axis.horizontal,
                                itemCount: filteredVideos.length,
                                itemBuilder: (context, index) {
                                  return customVideo(
                                      context: context,
                                      video: filteredVideos[index]);
                                },
                              ),
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: _currentVideo,
                              builder: (context, value, child) {
                                return SmoothPageIndicator(
                                  controller: _videoCountController,
                                  count: videos.length,
                                  effect: const ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 6,
                                    activeDotColor: Colors.black,
                                    dotColor: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
            loading: () =>
                Center(child: buildShimmerPromotionsColumn(context: context)),
            error: (error, stackTrace) {
              return Center(
                child: Text('NO PROMOTIONS YET'),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBanners(
      {required BuildContext context, required Promotion banner}) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.15,
      child: Stack(
        clipBehavior: Clip.none, // This allows overflow
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 175,
              // decoration: BoxDecoration(
              //   gradient: const LinearGradient(
              //     colors: [
              //       Color.fromARGB(41, 249, 180, 6),
              //       Color.fromARGB(113, 249, 180, 6)
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              //   borderRadius: BorderRadius.circular(8.0),
              // ),
              child: Image.network(
                banner.media ?? 'https://placehold.co/600x400/png',
                width: double.infinity,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    // If the image is fully loaded, show the image
                    return child;
                  }
                  // While the image is loading, show shimmer effect
                  return Container(
                    width: MediaQuery.sizeOf(context).width / 1.15,
                    height: 175,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customPoster(
      {required BuildContext context, required Promotion poster}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16), // Adjust spacing between notices
      child: Container(
        width: MediaQuery.of(context).size.width -
            32, // Poster width matches screen width
        child: Image.network(
          poster.media ?? 'https://placehold.co/600x400/png',
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; // Image loaded successfully
            } else {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 400, // Adjust height based on your poster size
                  color: Colors.white,
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              'https://placehold.co/600x400/png',
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }

  Widget customNotice(
      {required BuildContext context, required Promotion notice}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16), // Adjust spacing between posters
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Set the background color to white
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color.fromARGB(
                255, 225, 231, 236), // Set the border color to blue
            width: 2.0, // Adjust the width as needed
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFE30613), // Set the font color to blue
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notice.description!,
                    style: const TextStyle(
                      color: Color.fromRGBO(
                          0, 0, 0, 1), // Set the font color to blue
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildShimmerPromotionsColumn({
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      shimmerNotice(context: context),
      const SizedBox(height: 16),
      shimmerPoster(context: context),
      const SizedBox(height: 16),
      shimmerVideo(context: context),
    ],
  );
}

Widget shimmerNotice({
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}

Widget shimmerPoster({
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}

Widget shimmerVideo({
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 20, // Height for the title shimmer
              color: Colors.grey[300],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      ],
    ),
  );
}
