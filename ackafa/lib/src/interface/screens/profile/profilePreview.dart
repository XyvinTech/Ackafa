import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/getRatings.dart';
import 'package:ackaf/src/interface/common/cards.dart';
import 'package:ackaf/src/interface/common/components/svg_icon.dart';
import 'package:ackaf/src/interface/common/customModalsheets.dart';
import 'package:ackaf/src/interface/common/customTextfields.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/custom_video.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/profile/card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReviewsState extends StateNotifier<int> {
  ReviewsState() : super(2);

  void showMoreReviews(int totalReviews) {
    state = (state + 2).clamp(0, totalReviews);
  }
}

final reviewsProvider = StateNotifierProvider<ReviewsState, int>((ref) {
  return ReviewsState();
});

class ProfilePreview extends ConsumerWidget {
  final UserModel user;
  ProfilePreview({Key? key, required this.user}) : super(key: key);

  final List<String> svgIcons = [
    'assets/icons/instagram.svg',
    'assets/icons/linkedin.svg',
    'assets/icons/twitter.svg'
  ];

  final ValueNotifier<int> _currentVideo = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsToShow = ref.watch(reviewsProvider);
    PageController _videoCountController = PageController();

    _videoCountController.addListener(() {
      _currentVideo.value = _videoCountController.page!.round();
    });
    final ratingDistribution = getRatingDistribution(user);
    final averageRating = getAverageRating(user);
    final totalReviews = user.reviews!.length;

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
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                              color: Color(0xFF004797),
                            ),
                            onPressed: () {},
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
                              ref.invalidate(reviewsProvider);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.profilePicture != null
                            ? CircleAvatar(
                                radius: 45,
                                backgroundImage:
                                    NetworkImage(user.profilePicture!),
                              )
                            : const Icon(Icons.person),
                        const SizedBox(height: 10),
                        Text(
                          '${user.name!.firstName} ${user.name!.middleName} ${user.name!.lastName}',
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
                                if (user.companyLogo != null &&
                                    user.companyLogo != '')
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Image.network(
                                      user.companyLogo!,
                                      height: 33,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.designation!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 42, 41, 41),
                                  ),
                                ),
                                Text(
                                  user.companyName!,
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
                          Text(
                            'Member ID: ${user.membershipId}',
                            style: const TextStyle(
                              color: Colors.grey,
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
                            const Icon(Icons.phone, color: Color(0xFF004797)),
                            const SizedBox(width: 10),
                            Text(user.phoneNumbers!.personal.toString()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Color(0xFF004797)),
                            const SizedBox(width: 10),
                            Text(user.email!),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            if (user.socialMedia!.isNotEmpty)
                              const Column(
                                children: [
                                  Icon(FontAwesomeIcons.instagram,
                                      color: Color(0xFF004797)),
                                  // Flexible(child: Text(user.socialMedia![0].url!)),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xFF004797)),
                            const SizedBox(width: 10),
                            if (user.address != null)
                              Expanded(
                                child: Text(
                                  user.address!,
                                ),
                              )
                          ],
                        ),
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ReviewBarChart(
                        ratingDistribution: ratingDistribution,
                        averageRating: averageRating,
                        totalReviews: totalReviews,
                      ),
                    ),
                    if (user.id != id)
                      Row(
                        children: [
                          SizedBox(
                              width: 100,
                              child: customButton(
                                  label: 'Write a Review',
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (context) =>
                                          ShowWriteReviewSheet(
                                        userId: user.id!,
                                      ),
                                    );
                                  },
                                  fontSize: 15)),
                        ],
                      ),
                    if (user.reviews!.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reviewsToShow,
                        itemBuilder: (context, index) {
                          return ReviewsCard(
                            review: user.reviews![index],
                            ratingDistribution: ratingDistribution,
                            averageRating: averageRating,
                            totalReviews: totalReviews,
                          );
                        },
                      ),
                    if (reviewsToShow < user.reviews!.length)
                      TextButton(
                        onPressed: () {
                          ref
                              .read(reviewsProvider.notifier)
                              .showMoreReviews(user.reviews!.length);
                        },
                        child: Text('View More'),
                      ),
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
                    for (int index = 0;
                        index < user.socialMedia!.length;
                        index++)
                      customProfilePreviewLinks(index,
                          social: user.socialMedia![index]),
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
                      customProfilePreviewLinks(index,
                          website: user.websites![index]),
                    const SizedBox(
                      height: 30,
                    ),
                    if (user.video!.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            width: 500,
                            height: 260,
                            child: PageView.builder(
                              controller: _videoCountController,
                              itemCount: user.video!.length,
                              physics: const PageScrollPhysics(),
                              itemBuilder: (context, index) {
                                return profileVideo(
                                    context: context,
                                    video: user.video![index]);
                              },
                            ),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _currentVideo,
                            builder: (context, value, child) {
                              return SmoothPageIndicator(
                                controller: _videoCountController,
                                count: user.video!.length,
                                effect: const ExpandingDotsEffect(
                                  dotHeight: 8,
                                  dotWidth: 3,
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
                    const Row(
                      children: [
                        Text(
                          'Brochure',
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
                      itemCount: user.brochure!.length,
                      itemBuilder: (context, index) {
                        return BrochureCard(
                          brochure: user.brochure![index],
                          // onRemove: () => _removeCertificateCard(index),
                        );
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
          if (user.id != id)
            Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: customButton(
                              fontSize: 16, label: 'SAY HI', onPressed: () {}),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: customButton(
                              fontSize: 16,
                              label: 'SAVE CONTACT',
                              onPressed: () {}),
                        ),
                      ],
                    ))),
        ],
      ),
    );
  }

  Widget profileVideo({required BuildContext context, required Video video}) {
    final videoUrl = video.url;

    final ytController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl!)!,
      flags: const YoutubePlayerFlags(
        disableDragSeek: true,
        autoPlay: false,
        mute: false,
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
                  showVideoProgressIndicator: true,
                  onReady: () {
                    ytController.addListener(() {
                      if (ytController.value.playerState == PlayerState.ended) {
                        ytController.seekTo(Duration.zero);
                        ytController
                            .pause(); // Pause the video to prevent it from autoplaying again
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding customProfilePreviewLinks(int index,
      {SocialMedia? social, Website? website}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
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
                        color: const Color(0xFF004797),
                      )),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: social != null
                      ? Text('${social.url}')
                      : Text('${website!.url}')),
            ],
          )),
    );
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

class ReviewsCard extends StatelessWidget {
  final Map<int, int> ratingDistribution;
  final double averageRating;
  final int totalReviews;
  final Review review;

  const ReviewsCard({
    super.key,
    required this.ratingDistribution,
    required this.averageRating,
    required this.totalReviews,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final asyncUser = ref.watch(userProvider);
      return asyncUser.when(
        loading: () => Center(child: LoadingAnimation()),
        error: (error, stackTrace) {
          // Handle error state
          return Center(
            child: Text('Error loading promotions: $error'),
          );
        },
        data: (reviewer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    reviewer.profilePicture != null
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(reviewer.profilePicture!),
                          )
                        : const Icon(Icons.person),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${reviewer.name!.firstName!}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color.fromARGB(255, 42, 41, 41),
                      ),
                    ),
                    Text(
                      review.content!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
