import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_app/controller/video_controller.dart';
import 'package:video_app/widgets/reels_video_player.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var videoUrl;
  var filePath;
  final ReceivePort _port = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _checkPermission();
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0]; //id
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print("====== $progress");
      EasyLoading.showProgress(progress / 100, status: "$progress %");
      if (status == DownloadTaskStatus.complete && progress == 100) {
        EasyLoading.dismiss();
        // share
        Share.shareFiles([filePath], subject: "Share");
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    super.dispose();

    IsolateNameServer.removePortNameMapping('downloader_send_port');
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    EasyLoading.removeAllCallbacks();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  _downloadVideo(String videoUrl) async {
    EasyLoading.show(status: 'Loading... 0 %');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.mp4';
    filePath = "${appDocPath}/$fileName";
    print("===== $filePath");
    final taskId = await FlutterDownloader.enqueue(
      url: videoUrl,
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: appDocPath,
      fileName: fileName,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    print("==taskid== $taskId");
  }

  _checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    // print("=== ${statuses[Permission.storage]}");
    var status = statuses[Permission.storage];
    if (status == PermissionStatus.granted) {
      print("===permission granted===");
    } else if (status == PermissionStatus.permanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    } else if (status == PermissionStatus.denied) {
      print("===permission denied===");
      _checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<VideoController>(builder: (videoController) {
        return videoController.isLoaded
            ? PageView.builder(
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  if (EasyLoading.isShow) {
                    EasyLoading.dismiss();
                  }
                },
                itemCount: videoController.videoList.length,
                itemBuilder: (context, index) {
                  videoUrl =
                      '${videoController.videoList[index].videoFiles![1].link}';
                  return ReelsVideoPlayer(
                      thumbUrl: '${videoController.videoList[index].image}',
                      videoUrl: videoUrl);
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      }),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          _downloadVideo(videoUrl);
        },
        child: Icon(
          Icons.download,
        ),
      ),
    );
  }
}
