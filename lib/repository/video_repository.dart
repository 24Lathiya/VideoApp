import 'package:get/get.dart';
import 'package:video_app/api/api_client.dart';
import 'package:video_app/utils/app_constants.dart';

class VideoRepository extends GetxService {
  final ApiClient apiClient;
  VideoRepository({required this.apiClient});

  Future getVideoData() async {
    return await apiClient.getData(AppConstants.VIDEO_URI);
  }
}
