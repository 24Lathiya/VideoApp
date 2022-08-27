import 'package:get/get.dart';
import 'package:video_app/models/photo.dart';
import 'package:video_app/repository/photo_repository.dart';

class PhotoController extends GetxController {
  final PhotoRepository photoRepository;
  PhotoController({required this.photoRepository});

  List<Photos> _photoList = [];
  List<Photos> get photoList => _photoList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future getPhotoData() async {
    Response response = await photoRepository.getPhotoData();
    _isLoaded = true;
    if (response.statusCode == 200) {
      _photoList = [];
      _photoList.addAll(Photo.fromJson(response.body).photos!);
      update();
    }
  }
}
