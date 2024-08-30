import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/services/api_routes/promotions_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/promotions_model.dart';
import 'package:kssia/src/interface/common/custom_video.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../main_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _launchUrl({required url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
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
              // Filter promotions by type
              final banners =
                  promotions.where((promo) => promo.type == 'banner').toList();
              final posters =
                  promotions.where((promo) => promo.type == 'poster').toList();
              final notices =
                  promotions.where((promo) => promo.type == 'notice').toList();
              final videos =
                  promotions.where((promo) => promo.type == 'video').toList();
              final filteredVideos = videos
                  .where((video) => video.ytLink.startsWith('http'))
                  .toList();
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
                              'assets/icons/kssiaLogo.png',
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

                    if (posters.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: posters.length,
                          physics: const PageScrollPhysics(),
                          itemBuilder: (context, index) {
                            return customPoster(
                                context: context, poster: posters[index]);
                          },
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Notices
                    if (notices.isNotEmpty)
                      SizedBox(
                        height:
                            250, // This ensures that ListView has a bounded height
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: notices.length,
                          physics: const PageScrollPhysics(),
                          itemBuilder: (context, index) {
                            return customNotice(
                                context: context, notice: notices[index]);
                          },
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Videos
                    const SizedBox(height: 8),

                    if (filteredVideos.isNotEmpty)
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredVideos.length,
                          physics: const PageScrollPhysics(),
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
              // Handle error state
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
                banner.bannerImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      'https://placehold.co/600x400/png');
                },
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

  Widget customNotice(
      {required BuildContext context, required Promotion notice}) {
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
            const Padding(padding: EdgeInsets.all(8.0)),
            Text(
              notice.noticeTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet consectetur. Eget velit sagittis sapien in vitae ut. Lorem cursus sed nunc diam ullamcorper elit.',
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => notice.noticeLink.contains('http')
                  ? _launchUrl(url: notice.noticeLink)
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

  Widget customPoster(
      {required BuildContext context, required Promotion poster}) {
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
          poster.posterImageUrl,
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
        //               color: Color(0xFFE30613),
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
