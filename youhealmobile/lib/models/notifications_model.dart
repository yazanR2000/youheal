import '../utils/constants.dart';
import 'package:http/http.dart' as http;
class NotificationsModel {
  static Future getNotificationByUserId({required String token,required int page}) async {
    final uri = Uri.parse("${Constants.baseUrl}/notification/?page=$page");
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }
}