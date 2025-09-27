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
import 'package:ackaf/src/data/services/launch_url.dart';
import 'package:ackaf/src/interface/common/components/app_bar.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/custom_icon_container.dart';
import 'package:ackaf/src/interface/common/custom_video.dart';
import 'package:ackaf/src/interface/common/event_widget.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/constants/text_style.dart';
import 'package:ackaf/src/interface/screens/event_news/event.dart';
import 'package:ackaf/src/interface/screens/event_news/viewmore_event.dart';
import 'package:ackaf/src/interface/screens/main_pages/approvalPages/approval_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/people_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clearImageCache();
  }

  void _clearImageCache() {
    imageCache.clear(); // Clears all cached images
    imageCache.clearLiveImages();
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
        maxHeight = itemHeight + 30;
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

        return RefreshIndicator(
          color: Color(0xFFE30613),
          onRefresh: () async {
            ref.invalidate(fetchPromotionsProvider);
            ref.invalidate(fetchEventsProvider);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: asyncPromotions.when(
              data: (promotions) {
                final banners = promotions
                    .where((promo) => promo.type == 'banner')
                    .toList();
                final notices = promotions
                    .where((promo) => promo.type == 'notice')
                    .toList();
                final posters = promotions
                    .where((promo) => promo.type == 'poster')
                    .toList();
                final videos =
                    promotions.where((promo) => promo.type == 'video').toList();
                final filteredVideos = videos
                    .where((video) => video.link!.startsWith('http'))
                    .toList();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text('Hi,  ${widget.user.fullName}!',
                                style: const TextStyle(
                                    fontFamily: 'HelveticaNeue',
                                    fontSize: 19,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                style: TextStyle(
                                    fontFamily: 'HelveticaNeue',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                                'Here\'s to growing your family story, one branch at a time.',
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage(user: widget.user,isback: true,),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    child:
                                        Image.asset('assets/digitalcard1.png'),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Digital Card',
                                    style: AppTextStyles.subHeading16.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EventPage(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    child: Image.asset('assets/eventcard1.png'),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Events',
                                    style: AppTextStyles.subHeading16.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PeoplePage(isback: true,),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    child: Image.asset('assets/chatcard1.png'),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Chat',
                                    style: AppTextStyles.subHeading16.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

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
                                enableInfiniteScroll: false,
                                height: 200,
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

                      const SizedBox(height: 20),
                      // Events Carousel
                      asyncEvents.when(
                        data: (events) {
                          return events.isNotEmpty
                              ? Column(
                                  children: [
                                    // const Row(
                                    //   children: [
                                    //     Padding(
                                    //       padding: EdgeInsets.only(
                                    //           left: 25, top: 24),
                                    //       child: Text(
                                    //         'Events',
                                    //         style: TextStyle(
                                    //             fontSize: 17,
                                    //             fontWeight: FontWeight.w600),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    CarouselSlider(
                                      items: events.map((event) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          child: eventWidget(
                                            withImage: true,
                                            context: context,
                                            event: event,
                                          ),
                                        );
                                      }).toList(),
                                      options: CarouselOptions(
                                        enableInfiniteScroll: false,
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
                                    if (events.length > 1)
                                      _buildDotIndicator(_currentEventIndex,
                                          events.length, Colors.red),
                                  ],
                                )
                              : SizedBox();
                        },
                        loading: () => Center(child: LoadingAnimation()),
                        error: (error, stackTrace) => SizedBox(),
                      ),
                      SizedBox(
                        height: 20,
                      ),

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
                                enableInfiniteScroll: false,
                                scrollPhysics: notices.length > 1
                                    ? null
                                    : NeverScrollableScrollPhysics(),
                                autoPlay: notices.length > 1 ? true : false,
                                viewportFraction: 1,
                                height: _calculateDynamicHeight(notices),
                                autoPlayInterval: Duration(seconds: 4),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentNoticeIndex = index;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (notices.length > 1)
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
                                  enableInfiniteScroll: false,
                                  
                                  height: 
                                      MediaQuery.of(context).size.height * 0.7,
                                  scrollPhysics: posters.length > 1
                                      ? null
                                      : NeverScrollableScrollPhysics(),
                                  autoPlay: posters.length > 1,
                                  viewportFraction: 1,
                                  autoPlayInterval: Duration(seconds: 5),
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
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFFFFADA),
                              Color(0xFFFCDCAD),
                            ]), // Set the background color to white
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: const Color.fromARGB(255, 225, 231,
                                  236), // Set the border color to blue
                              width: 1.0, // Adjust the width as needed
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Image.asset(
                                      'assets/vision.png',
                                      scale: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, bottom: 10),
                                      child: Text('Vision',
                                          style: AppTextStyles.heading21
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                    ),
                                    SizedBox(height: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'In compliance with UAE laws, AKCAF’s aims to foster new connections '
                                          'between the two great nations with a deep commitment to support '
                                          'and serve the community in a dedicated and selfless manner.',
                                          style: AppTextStyles.subHeading16
                                              .copyWith(
                                            color: Colors.black,
                                            // scale text
                                            height: 1.4, // good line height
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: double.infinity,
      // width: MediaQuery.sizeOf(context).width / 1,
      child: AspectRatio(
        aspectRatio: 16 / 9, // Custom aspect ratio as 2:1
        child: Stack(
          clipBehavior: Clip.none, // This allows overflow
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  banner.media ?? '',
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image loaded successfully
                    }
                    // While the image is loading, show shimmer effect
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget customPoster({
  required BuildContext context,
  required Promotion poster,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Transform.translate(
      offset: const Offset(0, 6),
      child: Container(
        // height: MediaQuery.of(context).size.height*0.20,
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color.fromARGB(255, 226, 221, 221)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
/////poster image
            AspectRatio(
              aspectRatio: 3 / 4, // width : height = 3:4
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  poster.media ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Poster Image
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   width: MediaQuery.sizeOf(context).width * .95,
            //   height: 370,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Colors.white,
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Image.network(
            //       poster.media ?? '',
            //       fit: BoxFit.cover,
            //       errorBuilder: (context, error, stackTrace) {
            //         return Shimmer.fromColors(
            //           baseColor: Colors.grey[300]!,
            //           highlightColor: Colors.grey[100]!,
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: Colors.grey[300],
            //               borderRadius: BorderRadius.circular(8.0),
            //             ),
            //           ),
            //         );
            //       },
            //       loadingBuilder: (context, child, loadingProgress) {
            //         if (loadingProgress == null) return child;
            //         return Shimmer.fromColors(
            //           baseColor: Colors.grey[300]!,
            //           highlightColor: Colors.grey[100]!,
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: Colors.grey[300],
            //               borderRadius: BorderRadius.circular(8.0),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),

            // const Spacer(),
            const SizedBox(height: 20), // <-- small gap between image & button

            // Button
            if (poster.link != null &&
                poster.link != '' &&
                poster.link != 'null')
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                child: customButton(
                  buttonHeight: 40,
                  label: 'Know More',
                  onPressed: () {
                    // Add your navigation or action here
                    log(poster.link ?? '');
                    print(poster.link);
                    launchURL(poster.link ?? '');
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

// Widget customPoster(
//     {required BuildContext context, required Promotion poster}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     child: Column(
//       children: [
//         AspectRatio(
//           aspectRatio: 3 / 4,
//           child: Image.network(
//             poster.media ?? '',
//             fit: BoxFit.contain,
//             errorBuilder: (context, error, stackTrace) {
//               return Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                   ),
//                 ),
//               );
//             },
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) {
//                 return child; // Image loaded successfully
//               }
//               // While the image is loading, show shimmer effect
//               return Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding:const EdgeInsets.only(left: 8, right: 8, bottom: 10),
//           child: customButton(
//             buttonHeight: 40,
//             label: 'Know More',
//             onPressed: (){}
//           ),
//            )
//       ],
//     ),

//   );
// }

Widget customNotice(
    {required BuildContext context, required Promotion notice}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 18), // Adjust spacing between posters
    child: Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color.fromARGB(
              255, 225, 231, 236), // Set the border color to blue
          width: 1.0, // Adjust the width as needed
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
                Row(
                  children: [
                    Image.asset(
                      'assets/vision.png',
                      scale: 5,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      notice.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF661E92), // Set the font color to blue
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  notice.description!,
                  style: const TextStyle(color: Color(0xFF6A6A6A)
                      // Set the font color to blue
                      ),
                ),
                const Spacer(),
                if (notice.link != null &&
                    notice.link != '' &&
                    notice.link != 'null')
                  GestureDetector(
                    onTap: () {
                      log(notice.link ?? '');
                      launchURL(notice.link ?? '');
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            'Know more',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(
                                    0xFF004797) // Set the font color to blue
                                ),
                          ),
                          Icon(
                            color: Color(0xFFE30613),
                            Icons.arrow_forward_ios,
                            size: 14,
                          )
                        ],
                      ),
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
