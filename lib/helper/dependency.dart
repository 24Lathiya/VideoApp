import 'package:get/get.dart';
import 'package:video_app/api/api_client.dart';
import 'package:video_app/controller/photo_controller.dart';
import 'package:video_app/controller/video_controller.dart';
import 'package:video_app/repository/photo_repository.dart';
import 'package:video_app/repository/video_repository.dart';
import 'package:video_app/utils/app_constants.dart';

Future<void> init() async {
  Get.lazyPut(() => ApiClient(baseUrl: AppConstants.BASE_URL));

  Get.lazyPut(() => PhotoRepository(apiClient: Get.find()));
  Get.lazyPut(() => VideoRepository(apiClient: Get.find()));

  Get.lazyPut(() => PhotoController(photoRepository: Get.find()));
  Get.lazyPut(() => VideoController(videoRepository: Get.find()));
}
