import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_app/controller/video_controller.dart';
import 'package:video_app/widgets/reels_video_player.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<VideoController>(builder: (videoController) {
        return videoController.isLoaded
            ? PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: videoController.videoList.length,
                itemBuilder: (context, index) {
                  return ReelsVideoPlayer(
                      thumbUrl: '${videoController.videoList[index].image}',
                      videoUrl:
                          '${videoController.videoList[index].videoFiles!.first.link}');

                  /* Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              // image: AssetImage("assets/images/sample.png"),
                              image: NetworkImage(
                                  '${videoController.videoList[index].image}'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  );*/
                  /*CachedNetworkImage(
                    imageUrl: '${videoController.videoList[index].image}',
                    placeholder: (context, url) => const AspectRatio(
                      aspectRatio: 1.6,
                      child: BlurHash(hash: 'L5H2EC=PM+yV0g-mq.wG9c010J}I'),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  );*/
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }
}
