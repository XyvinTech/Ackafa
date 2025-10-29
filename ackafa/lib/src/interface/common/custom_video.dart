import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:ackaf/src/data/models/promotions_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AutoScrollText extends StatefulWidget {
  final String text;
  final double width;

  const AutoScrollText({required this.text, required this.width, Key? key})
      : super(key: key);

  @override
  _AutoScrollTextState createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  late ScrollController _scrollController;
  double scrollOffset = 0.0;
  double textWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setTextWidth();
      startScrolling();
    });
  }

  // Set the width of the text based on its actual rendered size
  void setTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    textWidth = textPainter.width;
  }

  void startScrolling() {
    if (_scrollController.hasClients) {
      // Adjust the scroll duration based on text width, the longer the text, the longer it scrolls
      final scrollDuration = (textWidth / 30)
          .clamp(8, 20)
          .toInt(); // Adjust the value for speed control

      Future.delayed(const Duration(seconds: 1), () {
        _scrollController
            .animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(
              seconds: scrollDuration), // Slower scrolling based on text length
          curve: Curves.linear,
        )
            .then((_) {
          _scrollController.jumpTo(0);
          startScrolling(); // Loop the scrolling
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 30, // Fixed height for the text
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics:
            const NeverScrollableScrollPhysics(), // Disable manual scrolling
        child: Row(
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 20), // Gap between repeated text
            Text(
              widget.text, // Repeat the text to create a marquee effect
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customVideo({required BuildContext context, required Promotion video}) {
  final videoUrl = video.link;

  final ytController = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(videoUrl ?? '')!,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      loop: true,
      mute: false,
    ),
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Auto-scrolling marquee for the video title
      // Padding(
      //   padding: const EdgeInsets.only(top: 10),
      //   child: AutoScrollText(
      //     text: video.title ?? '',
      //     width: MediaQuery.of(context).size.width *
      //         0.9, // Set width to avoid taking full screen
      //   ),
      // ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: MediaQuery.of(context).size.width, // Full-screen width
          height: 200,
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent background
          ),
          child: ClipRRect(
            child: YoutubePlayer(
              controller: ytController,
              aspectRatio: 16 / 9,
            ),
          ),
        ),
      ),
    ],
  );
}
