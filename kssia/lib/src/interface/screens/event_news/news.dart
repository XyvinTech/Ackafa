import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/services/api_routes/news_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/news_model.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class NewsPage extends StatelessWidget {
  final List<News> news;

  const NewsPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = ref.watch(currentIndexProvider);

        void _nextNews() {
          ref.read(currentIndexProvider.notifier).state =
              (currentIndex + 1) % news.length;
        }

        void _previousNews() {
          ref.read(currentIndexProvider.notifier).state =
              (currentIndex - 1 + news.length) % news.length;
        }

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200,
                              child: Image.network(
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      'https://placehold.co/600x400/png');
                                },
                                news[currentIndex]
                                    .image, // Replace with your image URL
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news[currentIndex].category,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    news[currentIndex].title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    SliverFillRemaining(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Text(
                            news[currentIndex].content!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _previousNews,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 224, 219, 219)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Color(0xFF004797)),
                          SizedBox(width: 8),
                          Text('Previous',
                              style: TextStyle(color: Color(0xFF004797))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: _nextNews,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 224, 219, 219)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                      ),
                      child: const Row(
                        children: [
                          Text('Next',
                              style: TextStyle(color: Color(0xFF004797))),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Color(0xFF004797)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// void main() {
//   runApp(MaterialApp(
//     home: NewsPage(),
//   ));
// }
