import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/getRatings.dart';
import 'package:ackaf/src/interface/common/loading.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Reviews'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.whatsapp),
                onPressed: () {
                  // Placeholder for WhatsApp functionality
                },
              ),
            ],
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
          ),
          body: asyncUser.when(
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading promotions: $error'),
              );
            },
            data: (user) {
              final ratingDistribution = getRatingDistribution(user);
              final averageRating = getAverageRating(user);
              final totalReviews = user.reviews!.length;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 1.0,
                      color: Colors.grey[300], // Divider color
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ReviewBarChart(
                        ratingDistribution: ratingDistribution,
                        averageRating: averageRating,
                        totalReviews: totalReviews,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: user.reviews!.length,
                      itemBuilder: (context, index) {
                        return ReviewsCard(
                          review: user.reviews![index],
                          ratingDistribution: ratingDistribution,
                          averageRating: averageRating,
                          totalReviews: totalReviews,
                        );
                      },
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Placeholder for 'View More' functionality
                        },
                        child: const Text('View More'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
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
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  height: 60,
                  width: 80,
                  color: Color(0xFFFFFCF2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Color(0xFFF5B358)),
                      SizedBox(width: 4),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(
                            color: Color(0xFFF5B358),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '$totalReviews Reviews',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 16), // Space between left and right side

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
                    SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 4.5,
                        borderRadius: BorderRadius.circular(10),
                        value: percentage,
                        backgroundColor: Colors.grey[300],
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$starCount',
                      style: TextStyle(color: Colors.grey),
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
          return Row(
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
                      : Icon(Icons.person),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }
}
