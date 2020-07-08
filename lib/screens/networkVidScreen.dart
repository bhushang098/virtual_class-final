import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:video_player/video_player.dart';

class NetworkPlayer extends StatefulWidget {
  //DefaultPlayer({Key key}) : super(key: key);
  String url;

  NetworkPlayer(this.url);

  @override
  _NetworkPlayerState createState() => _NetworkPlayerState(url);
}

class _NetworkPlayerState extends State<NetworkPlayer> {
  FlickManager flickManager;
  String url;

  _NetworkPlayerState(this.url);

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(url),
      autoPlay: false,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager.autoResume();
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          preferredDeviceOrientation: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            controls: FlickPortraitControls(),
          ),
          flickVideoWithControlsFullscreen: FlickVideoWithControls(
            controls: FlickLandscapeControls(),
          ),
        ),
      ),
    );
  }
}
