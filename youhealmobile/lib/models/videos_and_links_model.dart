import 'package:http/http.dart' as http;
import 'package:youhealmobile/utils/constants.dart';

class VideosAndLinksModel {
  static Future getAllVideos({required int page, required String token}) async {
    final url =
        Uri.parse("${Constants.baseUrl}/video/");
    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }

  static Future getAllLinks({required int page, required String token}) async {
    final url =
        Uri.parse("${Constants.baseUrl}/link/");
    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }
}
