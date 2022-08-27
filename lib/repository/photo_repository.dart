import 'package:get/get.dart';
import 'package:video_app/api/api_client.dart';
import 'package:video_app/utils/app_constants.dart';

class PhotoRepository extends GetxService {
  final ApiClient apiClient;
  PhotoRepository({required this.apiClient});

  Future<Response> getPhotoData() async {
    return await apiClient.getData(AppConstants.PHOTO_URI);
  }
}
