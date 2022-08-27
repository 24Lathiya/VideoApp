import 'package:get/get.dart';
import 'package:video_app/models/video.dart';
import 'package:video_app/repository/video_repository.dart';

class VideoController extends GetxController {
  final VideoRepository videoRepository;
  VideoController({required this.videoRepository});

  List<Videos> _videoList = [];
  List<Videos> get videoList => _videoList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future getVideoData() async {
    Response response = await videoRepository.getVideoData();
    _isLoaded = true;
    if (response.statusCode == 200) {
      _videoList = [];
      _videoList.addAll(Video.fromJson(response.body).videos!);
      update();
    }
  }
}
