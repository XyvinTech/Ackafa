 import 'package:flutter/material.dart';
import 'package:kssia/src/data/models/promotions_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Widget customVideo(
      {required BuildContext context, required Promotion video}) {
    final videoUrl =
        video.ytLink; // Assuming 'url' is the key containing the video URL

    final ytController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        disableDragSeek: true,
        autoPlay: false,
        mute: false,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(video.videoTitle,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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