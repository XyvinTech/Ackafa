import 'dart:developer';

import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/common/cards.dart';
import 'package:ackaf/src/interface/common/components/svg_icon.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ProfilePreview extends ConsumerWidget {
  final UserModel user;
  ProfilePreview({super.key, required this.user});

  final List<String> svgIcons = [
    'assets/icons/instagram.svg',
    'assets/icons/linkedin.svg',
    'assets/icons/twitter.svg',
    'assets/icons/icons8-facebook.svg'
  ];

  final ValueNotifier<int> _currentVideo = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageController _videoCountController = PageController();

    _videoCountController.addListener(() {
      _currentVideo.value = _videoCountController.page!.round();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (id.toString() == user.id.toString())
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              icon: const Icon(
                                size: 18,
                                Icons.edit,
                                color: Color(0xFFE30613),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => DetailsPage(),
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    transitionsBuilder: (_, a, __, c) =>
                                        FadeTransition(opacity: a, child: c),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                            icon: const Icon(
                              size: 20,
                              Icons.close,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.image != null
                            ? CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  user.image ?? 'https://placehold.co/600x400',
                                ),
                              )
                            : const Icon(Icons.person),
                        const SizedBox(height: 10),
                        Text(
                          '${user.name!.first!} ${user.name?.middle ?? ''} ${user.name?.last ?? ''}',
                          style: const TextStyle(
                            color: Color(0xFF2C2829),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                user.company?.logo != null &&
                                        user.company?.logo != ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: Image.network(
                                          user.company!.logo!,
                                          height: 33,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.company?.designation ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 42, 41, 41),
                                  ),
                                ),
                                Text(
                                  user.company?.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 234, 226, 226))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: Image.asset(
                              'assets/icons/ackaf_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.phone, color: Color(0xFFE30613)),
                            const SizedBox(width: 10),
                            Text(user.phone.toString()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Color(0xFFE30613)),
                            const SizedBox(width: 10),
                            Text(user.email!),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (user.address != null)
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xFFE30613)),
                              const SizedBox(width: 10),
                              if (user.address != null)
                                Expanded(
                                  child: Text(
                                    user.address!,
                                  ),
                                )
                            ],
                          ),
                        const SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     const SvgIcon(
                        //       assetName: 'assets/icons/whatsapp.svg',
                        //       color: Color(0xFFE30613),
                        //       size: 25,
                        //     ),
                        //     const SizedBox(width: 10),
                        //     if (user.whatsappNumber != null)
                        //       Expanded(
                        //         child: Text(user.phoneNumbers!.whatsappNumber!),
                        //       )
                        //   ],
                        // ),
                        // const SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     const SvgIcon(
                        //       assetName: 'assets/icons/whatsapp-business.svg',
                        //       color: Color(0xFFE30613),
                        //       size: 23,
                        //     ),
                        //     const SizedBox(width: 10),
                        //     if (user.phoneNumbers?.whatsappBusinessNumber !=
                        //         null)
                        //       Expanded(
                        //         child: Text(user.phoneNumbers?.whatsappNumber??''),
                        //       )
                        //   ],
                        // ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/icons/qoutes.png'),
                        ),
                      ],
                    ),
                    if (user.bio != null &&
                        user.bio != '' &&
                        user.bio != 'null')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Flexible(child: Text('''${user.bio}''')),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 50,
                    ),
                    if (user.social!.isNotEmpty)
                      const Row(
                        children: [
                          Text(
                            'Social Media',
                            style: TextStyle(
                                color: Color(0xFF2C2829),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    for (int index = 0; index < user.social!.length; index++)
                      customSocialPreview(index, social: user.social![index]),
                    if (user.websites!.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Row(
                          children: [
                            Text(
                              'Websites & Links',
                              style: TextStyle(
                                  color: Color(0xFF2C2829),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    for (int index = 0; index < user.websites!.length; index++)
                      customWebsitePreview(index,
                          website: user.websites![index]),
                    const SizedBox(
                      height: 30,
                    ),
                    if (user.videos!.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            width: 500,
                            height: 260,
                            child: PageView.builder(
                              controller: _videoCountController,
                              itemCount: user.videos!.length,
                              physics: const PageScrollPhysics(),
                              itemBuilder: (context, index) {
                                return profileVideo(
                                    context: context,
                                    video: user.videos![index]);
                              },
                            ),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _currentVideo,
                            builder: (context, value, child) {
                              return SmoothPageIndicator(
                                controller: _videoCountController,
                                count: user.videos!.length,
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
                    const SizedBox(
                      height: 40,
                    ),
                    if (user.certificates!.isNotEmpty)
                      const Row(
                        children: [
                          Text(
                            'Certificates',
                            style: TextStyle(
                                color: Color(0xFF2C2829),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ListView.builder(
                      shrinkWrap:
                          true, // Let ListView take up only as much space as it needs
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable ListView's internal scrolling
                      itemCount: user.certificates!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0), // Space between items
                          child: CertificateCard(
                            certificate: user.certificates![index],
                            onRemove: null,
                          ),
                        );
                      },
                    ),
                    if (user.awards!.isNotEmpty)
                      const Row(
                        children: [
                          Text(
                            'Awards',
                            style: TextStyle(
                                color: Color(0xFF2C2829),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    GridView.builder(
                      shrinkWrap:
                          true, // Let GridView take up only as much space as it needs
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 8.0, // Space between columns
                        mainAxisSpacing: 8.0, // Space between rows
                        childAspectRatio: .9, // Aspect ratio for the cards
                      ),
                      itemCount: user.awards!.length,
                      itemBuilder: (context, index) {
                        return AwardCard(
                          award: user.awards![index],
                          onRemove: null,
                        );
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
          // if (user.id != id)
          //   Positioned(
          //       bottom: 20,
          //       left: 20,
          //       right: 20,
          //       child: SizedBox(
          //           height: 50,
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             children: [
          //               Flexible(
          //                 child: customButton(
          //                     fontSize: 16, label: 'SAY HI', onPressed: () {}),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Flexible(
          //                 child: customButton(
          //                     fontSize: 16,
          //                     label: 'SAVE CONTACT',
          //                     onPressed: () {}),
          //               ),
          //             ],
          //           ))),
        ],
      ),
    );
  }

  Widget profileVideo({required BuildContext context, required Link video}) {
    final videoUrl = video.link;

    final ytController = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(videoUrl ?? '')!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        enableJavaScript: true,
        loop: true,
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(video.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width:
                  MediaQuery.of(context).size.width - 32, // Full-screen width
              height: 200,
              decoration: BoxDecoration(
                color: Colors.transparent, // Transparent background
                borderRadius: BorderRadius.circular(8.0),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: YoutubePlayer(
                  controller: ytController,
                  aspectRatio: 16 / 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding customSocialPreview(int index, {Link? social}) {
    log('Icons: ${svgIcons[index]}');
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          if (social != null) {
            _launchURL(social.link ?? '');
          }
        },
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF2F2F2),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      widthFactor: 1.0,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          width: 42,
                          height: 42,
                          child: SvgIcon(
                            assetName: svgIcons[index],
                            color: Color(0xFFE30613),
                          ))),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text('${social?.name}')),
              ],
            )),
      ),
    );
  }

  Padding customWebsitePreview(int index, {Link? website}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          if (website != null) {
            _launchURL(website.link ?? '');
          }
        },
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF2F2F2),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Align(
                    alignment: Alignment.topCenter,
                    widthFactor: 1.0,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        width: 42,
                        height: 42,
                        child: Icon(
                          Icons.language,
                          color: Color(0xFFE30613),
                        )),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text('${website!.name}')),
              ],
            )),
      ),
    );
  }
}

void _launchURL(String url) async {
  // Check if the URL starts with 'http://' or 'https://', if not add 'http://'
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'http://' + url;
  }

  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print(e);
  }
}

class ReviewBarChart extends StatelessWidget {
  final Map<int, int> ratingDistribution;
  final double averageRating;
  final int totalReviews;

  const ReviewBarChart({
    Key? key,
    required this.ratingDistribution,
    required this.averageRating,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: Star icon, average rating, and total reviews
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  height: 60,
                  width: 80,
                  color: const Color(0xFFFFFCF2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFF5B358)),
                      const SizedBox(width: 4),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: Color(0xFFF5B358),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$totalReviews Reviews',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(width: 16), // Space between left and right side

        // Right side: Rating bars
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(5, (index) {
                int starCount = 5 - index;
                int reviewCount = ratingDistribution[starCount] ?? 0;
                double percentage =
                    totalReviews > 0 ? reviewCount / totalReviews : 0;

                return Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 4.5,
                        borderRadius: BorderRadius.circular(10),
                        value: percentage,
                        backgroundColor: Colors.grey[300],
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$starCount',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
