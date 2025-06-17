
import 'package:chuchu/core/utils/adapt.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  State createState() => YoutubePlayerWidgetState();
}

class YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataInit();
  }

  void _dataInit() {
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    try{
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }catch(e){
      print('===e======$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: videoMoment(),
        ),
      ),
    );
  }

  Widget videoMoment() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
      child: _videoSurfaceDrawingWidget(),
    );
  }

  Widget _videoSurfaceDrawingWidget() {
    if(_youtubeController == null) return Container();
    return YoutubePlayer(
      controller: _youtubeController!,
      showVideoProgressIndicator: false,
      onReady: () {
        print('Player is ready.');
      },
    );
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }
}
