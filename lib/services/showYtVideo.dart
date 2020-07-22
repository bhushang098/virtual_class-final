import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YtVideoService {
  YoutubePlayerController _controller;

  Widget showYoutubeVideo(String uTubeVdLink) {
    if (uTubeVdLink == null) {
    } else {
      if (uTubeVdLink.isNotEmpty) {
        try {
          _controller = YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(uTubeVdLink));
          return Container(
            child: Column(
              children: <Widget>[
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
              ],
            ),
          );
        } catch (e) {
          print(e.toString());
        }
      }
    }
    return Container();
  }
}
