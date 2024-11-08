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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends ConsumerStatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentBannerIndex = 0;
  int _currentNoticeIndex = 0;
  int _currentPosterIndex = 0;
  int _currentEventIndex = 0;
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialApprovals();
  }

  Future<void> _fetchInitialApprovals() async {
    await ref.read(approvalNotifierProvider.notifier).fetchMoreApprovals();
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
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final int numLines = (text.length / (screenWidth / fontSize)).ceil();
    return numLines * fontSize * 1.2;
  }

  CarouselController controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncPromotions = ref.watch(fetchPromotionsProvider(token));
        final asyncEvents = ref.watch(fetchEventsProvider);

        return Scaffold(
          backgroundColor: Colors.white,
          body: asyncPromotions.when(
            data: (promotions) {
              final banners =
                  promotions.where((promo) => promo.type == 'banner').toList();
              final notices =
                  promotions.where((promo) => promo.type == 'notice').toList();
              final posters =
                  promotions.where((promo) => promo.type == 'poster').toList();
              final videos =
                  promotions.where((promo) => promo.type == 'video').toList();
              final filteredVideos = videos
                  .where((video) => video.link!.startsWith('http'))
                  .toList();
              posters.forEach((poster) {
                if (poster.media != null) {
                  CachedNetworkImageProvider(poster.media!)
                      .resolve(ImageConfiguration());
                }
              });
              banners.forEach((banner) {
                if (banner.media != null) {
                  CachedNetworkImageProvider(banner.media!)
                      .resolve(ImageConfiguration());
                }
              });

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(),
                    const SizedBox(height: 20),

                    // Banner Carousel
                    if (banners.isNotEmpty)
                      Column(
                        children: [
                          CarouselSlider(
                            items: banners.map((banner) {
                              return _buildBanners(
                                  context: context, banner: banner);
                            }).toList(),
                            options: CarouselOptions(
                              height: 175,
                              scrollPhysics: banners.length > 1
                                  ? null
                                  : NeverScrollableScrollPhysics(),
                              autoPlay: banners.length > 1 ? true : false,
                              viewportFraction: 1,
                              autoPlayInterval: Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentBannerIndex = index;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Notices Carousel
                    if (notices.isNotEmpty)
                      Column(
                        children: [
                          CarouselSlider(
                            items: notices.map((notice) {
                              return customNotice(
                                  context: context, notice: notice);
                            }).toList(),
                            options: CarouselOptions(
                              scrollPhysics: notices.length > 1
                                  ? null
                                  : NeverScrollableScrollPhysics(),
                              autoPlay: notices.length > 1 ? true : false,
                              viewportFraction: 1,
                              height: _calculateDynamicHeight(notices),
                              autoPlayInterval: Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentNoticeIndex = index;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildDotIndicator(
                              _currentNoticeIndex,
                              notices.length,
                              const Color.fromARGB(255, 39, 38, 38)),
                        ],
                      ),

                    if (posters.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            CarouselSlider(
                              items: posters.asMap().entries.map((entry) {
                                int index = entry.key;
                                Promotion poster = entry.value;

                                return KeyedSubtree(
                                  key: ValueKey(index),
                                  child: customPoster(
                                      context: context, poster: poster),
                                );
                              }).toList(),
                              options: CarouselOptions(
                                height: 420,
                                scrollPhysics: posters.length > 1
                                    ? null
                                    : NeverScrollableScrollPhysics(),
                                autoPlay: posters.length > 1,
                                viewportFraction: 1,
                                autoPlayInterval: Duration(seconds: 3),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentPosterIndex = index;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                    // Events Carousel
                    asyncEvents.when(
                      data: (events) {
                        events.forEach((event) {
                          if (event.image != null) {
                            CachedNetworkImageProvider(event.image!)
                                .resolve(ImageConfiguration());
                          }
                        });
                        return events.isNotEmpty
                            ? Column(
                                children: [
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
                                  CarouselSlider(
                                    items: events.map((event) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        child: eventWidget(
                                          withImage: true,
                                          context: context,
                                          event: event,
                                        ),
                                      );
                                    }).toList(),
                                    options: CarouselOptions(
                                      height: 380,
                                      scrollPhysics: events.length > 1
                                          ? null
                                          : NeverScrollableScrollPhysics(),
                                      autoPlay:
                                          events.length > 1 ? true : false,
                                      viewportFraction: 1,
                                      autoPlayInterval: Duration(seconds: 3),
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentEventIndex = index;
                                        });
                                      },
                                    ),
                                  ),
                                  _buildDotIndicator(_currentEventIndex,
                                      events.length, Colors.red),
                                ],
                              )
                            : SizedBox();
                      },
                      loading: () => Center(child: LoadingAnimation()),
                      error: (error, stackTrace) => SizedBox(),
                    ),

                    const SizedBox(height: 16),

                    // Videos Carousel
                    if (filteredVideos.isNotEmpty)
                      Column(
                        children: [
                          CarouselSlider(
                            items: filteredVideos.map((video) {
                              return customVideo(
                                  context: context, video: video);
                            }).toList(),
                            options: CarouselOptions(
                              height: 225,
                              scrollPhysics: videos.length > 1
                                  ? null
                                  : NeverScrollableScrollPhysics(),
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentVideoIndex = index;
                                });
                              },
                            ),
                          ),
                          _buildDotIndicator(_currentVideoIndex,
                              filteredVideos.length, Colors.black),
                        ],
                      ),
                  ],
                ),
              );
            },
            loading: () =>
                Center(child: buildShimmerPromotionsColumn(context: context)),
            error: (error, stackTrace) =>
                Center(child: Text('NO PROMOTIONS YET')),
          ),
        );
      },
    );
  }

  // Method to build a dot indicator for carousels
  Widget _buildDotIndicator(int currentIndex, int itemCount, Color color) {
    return Center(
      child: SmoothPageIndicator(
        controller: PageController(initialPage: currentIndex),
        count: itemCount,
        effect: WormEffect(
          dotHeight: 10,
          dotWidth: 10,
          activeDotColor: color,
          dotColor: Colors.grey,
        ),
      ),
    );
  }
}

Widget _buildBanners(
    {required BuildContext context, required Promotion banner}) {
  return Container(
    width: MediaQuery.sizeOf(context).width / 1.15,
    child: AspectRatio(
      aspectRatio: 2 / 1, // Custom aspect ratio as 2:1
      child: Stack(
        clipBehavior: Clip.none, // This allows overflow
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CachedNetworkImage(
                imageUrl: banner.media ?? '',
                fit: BoxFit.fill,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget customPoster(
    {required BuildContext context, required Promotion poster}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: AspectRatio(
      aspectRatio: 19 / 20,
      child: CachedNetworkImage(
        imageUrl: poster.media ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
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
        color: Color(0xFFEDDCF3), // Set the background color to white
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
                    color: Color(0xFF661E92), // Set the font color to blue
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notice.description!,
                  style: const TextStyle(color: Color(0xFF6A6A6A)
                      // Set the font color to blue
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
