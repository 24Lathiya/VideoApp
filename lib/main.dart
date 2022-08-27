import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_app/controller/video_controller.dart';
import 'package:video_app/helper/dependency.dart' as dept;
import 'package:video_app/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dept.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    await Get.find<VideoController>().getVideoData();
    // await Get.find<PhotoController>().getPhotoData();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
