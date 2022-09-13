import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsVideoPlayer extends StatefulWidget {
  final String thumbUrl;
  final String videoUrl;
  const ReelsVideoPlayer(
      {Key? key, required this.thumbUrl, required this.videoUrl})
      : super(key: key);

  @override
  State<ReelsVideoPlayer> createState() => _ReelsVideoPlayerState();
}

class _ReelsVideoPlayerState extends State<
    ReelsVideoPlayer> /*with AutomaticKeepAliveClientMixin<ReelsVideoPlayer> */ {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  // late var height;
  // late var width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("===url ${widget.videoUrl}");
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.addListener(() {
      setState(() {});
    });

    _controller.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoInitialize: true,
        autoPlay: true,
        looping: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      );

      setState(() {});
    });
    // _controller.setLooping(true);
    // _controller.play();

    // height = _controller.value.size.height;
    // width = _controller.value.size.width;
  }

  /*@override
  bool get wantKeepAlive => true;*/

  @override
  void dispose() {
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // child: VideoPlayer(_controller),
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              )
            : /*AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: CachedNetworkImage(
                  imageUrl: widget.thumbUrl,
                ),
              ),*/
            CachedNetworkImage(
                imageUrl: widget.thumbUrl,
              ),
      ),
    );
  }
}
