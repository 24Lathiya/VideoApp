import 'package:get/get.dart';
import 'package:video_app/utils/app_constants.dart';

class ApiClient extends GetConnect implements GetxService {
  final String baseUrl;
  ApiClient({
    required this.baseUrl,
  }) {
    timeout = Duration(seconds: 30);
  }

  Future getData(String uri) async {
    try {
      Response response = await get(uri,
          headers: {'Authorization': '${AppConstants.API_TOKEN}'});
      print("===response : ${response.body}");
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
