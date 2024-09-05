import 'dart:async';
import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/promotions_model.dart';
import 'package:ackaf/src/data/services/api_routes/promotions_api.dart';
import 'package:ackaf/src/interface/common/custom_video.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _bannerScrollController = ScrollController();
  ScrollController _noticeScrollController = ScrollController();
  ScrollController _posterScrollController = ScrollController();

  Timer? _bannerScrollTimer;
  Timer? _noticeScrollTimer;
  Timer? _posterScrollTimer;

  int _currentBannerIndex = 0;
  int _currentNoticeIndex = 0;
  int _currentPosterIndex = 0;

  // GlobalKeys to measure item width
  final GlobalKey _bannerKey = GlobalKey();
  final GlobalKey _noticeKey = GlobalKey();
  final GlobalKey _posterKey = GlobalKey();

  Future<void> _launchUrl({required url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  double _getItemWidth(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 200.0;
  }

  void startAutoScroll({
    required ScrollController controller,
    required int itemCount,
    required int currentIndex,
    required GlobalKey itemKey,
    required Function(int) onIndexChanged,
  }) {
    Timer.periodic(Duration(seconds: 2), (timer) {
      currentIndex++;
      if (currentIndex >= itemCount) {
        currentIndex = 0;
      }
      final itemWidth = _getItemWidth(itemKey);
      controller.animateTo(
        currentIndex * itemWidth,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      onIndexChanged(currentIndex);
    });
  }

  @override
  void dispose() {
    _bannerScrollController.dispose();
    _noticeScrollController.dispose();
    _posterScrollController.dispose();

    _bannerScrollTimer?.cancel();
    _noticeScrollTimer?.cancel();
    _posterScrollTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncPromotions = ref.watch(fetchPromotionsProvider(token));

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

              if (banners.isNotEmpty) {
                _bannerScrollTimer =
                    Timer.periodic(Duration(seconds: 3), (timer) {
                  _currentBannerIndex++;
                  if (_currentBannerIndex >= banners.length) {
                    _currentBannerIndex = 0;
                  }
                  final itemWidth = _getItemWidth(_bannerKey);
                  if (_bannerScrollController.hasClients) {
                    _bannerScrollController.animateTo(
                      _currentBannerIndex * itemWidth,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              }

              if (notices.isNotEmpty) {
                _noticeScrollTimer =
                    Timer.periodic(Duration(seconds: 4), (timer) {
                  _currentNoticeIndex++;
                  if (_currentNoticeIndex >= notices.length) {
                    _currentNoticeIndex = 0;
                  }
                  if (_noticeScrollController.hasClients) {
                    final itemWidth = _getItemWidth(_noticeKey);
                    _noticeScrollController.animateTo(
                      _currentNoticeIndex * itemWidth,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              }

              if (posters.isNotEmpty) {
                _posterScrollTimer =
                    Timer.periodic(Duration(seconds: 5), (timer) {
                  _currentPosterIndex++;
                  if (_currentPosterIndex >= posters.length) {
                    _currentPosterIndex = 0;
                  }
                  if (_posterScrollController.hasClients) {
                    final itemWidth = _getItemWidth(_bannerKey);
                    _posterScrollController.animateTo(
                      _currentPosterIndex * itemWidth,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: AppBar(
                        toolbarHeight: 45.0,
                        scrolledUnderElevation: 0,
                        backgroundColor: Colors.white,
                        elevation: 0,
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
                            icon: Icon(Icons.notifications_none_outlined),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationPage()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenuPage()), // Navigate to MenuPage
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    promotions.isEmpty
                        ? Center(
                            child: Text(
                              'No Promotions Yet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 8, right: 8),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search promotions',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 214, 211, 211)),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 217, 212, 212)),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),

                    if (banners.isNotEmpty)
                      Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Container(
                          color: Colors.transparent,
                          height: 140,
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
                        height: 150,
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
                    const SizedBox(height: 16),

                    if (posters.isNotEmpty)
                      SizedBox(
                        height: 250,
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
                    const SizedBox(height: 20),

                    // Videos section (no auto-scroll)
                    if (filteredVideos.isNotEmpty)
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredVideos.length,
                          itemBuilder: (context, index) {
                            return customVideo(
                                context: context, video: filteredVideos[index]);
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading promotions: $error'),
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
      width: MediaQuery.sizeOf(context).width / 1.20,
      child: Stack(
        clipBehavior: Clip.none, // This allows overflow
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(41, 249, 180, 6),
                    Color.fromARGB(113, 249, 180, 6)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
                width: double.infinity,
                banner.link ?? 'https://placehold.co/600x400/png',
                fit: BoxFit.cover,
              ),
              // child: Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       SizedBox(width: 100),
              //       SizedBox(width: 40),
              //       Flexible(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             SizedBox(
              //               height: 20,
              //             ),
              //             Container(
              //               decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(10)),
              //               child: const Padding(
              //                 padding: EdgeInsets.only(left: 8, right: 8),
              //                 child: Text(
              //                   'Lorem ipsum dolor sit amet',
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 13,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Row(
              //               children: [
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Flexible(
              //                   child: Text(
              //                     'Lorem ipsum dolor sit amet',
              //                     style: TextStyle(
              //                         fontSize: 16, fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ),
          ),
          // Positioned(
          //   left: -10,
          //   bottom: -10, // Make this value more negative to move the image up
          //   child: SizedBox(
          //     width: 240, // Adjust the width of the image
          //     height: 240, // Adjust the height of the image
          //     child: Image.asset(
          //       'assets/homegirl.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
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
            32, // Notice width matches screen width
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(41, 249, 180, 6),
              Color.fromARGB(113, 249, 180, 6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/posterside_logo.svg', // Ensure this path is correct
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 15),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              poster.title ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (poster.description != null)
              Text(
                poster.description!,
              ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => poster.link!.contains('http')
                  ? _launchUrl(url: poster.link)
                  : null,
              child: const Row(
                children: [
                  Text(
                    'Know More',
                    style: TextStyle(
                      color: Color(0xFF040F4F), // Change the color here
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF040F4F), // Change the icon color here
                  ),
                ],
              ),
            ),
          ],
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
        width: MediaQuery.of(context).size.width -
            32, // Poster width matches screen width
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color.fromARGB(255, 225, 231, 236),
            width: 2.0,
          ),
        ),
        child: Image.network(
          notice.media ?? 'https://placehold.co/600x400/png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
                fit: BoxFit.cover, 'https://placehold.co/600x400/png');
          },
        ),
        // child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     SvgPicture.asset(
        //       'assets/icons/membership_logo.svg',
        //       width: 40,
        //       height: 40,
        //     ),
        //     const SizedBox(width: 8),
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: const [
        //           Text(
        //             'KSSIA Membership',
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 18,
        //               color: Color(0xFF004797),
        //             ),
        //           ),
        //           SizedBox(height: 8),
        //           Text(
        //             'Lorem ipsum dolor sit amet consectetur. Eget velit sagittis sapien in vitae ut. Lorem cursus sed nunc diam ullamcorper elit.',
        //             style: TextStyle(
        //               color: Color.fromRGBO(0, 0, 0, 1),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
