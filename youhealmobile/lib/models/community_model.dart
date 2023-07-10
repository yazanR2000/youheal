import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as httpParser;
import '../utils/constants.dart';

class CommunityModel {
  static Future getCommentsByPostId(
      {required int postId, required int page, required String token}) async {
    final uri = Uri.parse("${Constants.baseUrl}/comment/$postId?page=$page");
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }

  static Future getCommunityPosts(
      {required int page, required String token}) async {
    final uri = Uri.parse("${Constants.baseUrl}/post?page=$page");
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }

  static Future addNewPostOrComment(
      {required List<dynamic> files,
      required String path,
      required String content,
      required String token}) async {
    var url =
        Uri.parse('${Constants.baseUrl}$path'); // Replace with your server URL

    var request = http.MultipartRequest('POST', url);

    // Add files to the request
    for (var file in files) {
      var tempFile = file;
      if (tempFile.path.toString().contains("aac")) {
        tempFile = await file.copy(file.path + '_copy');
      }

      httpParser.MediaType? contentType;
      String? firstType;
      final type = tempFile.path.split('/').last.toString().split('.')[1];
      if (type == "mp4") {
        firstType = "video";
        contentType = httpParser.MediaType("video", type);
      } else if (type == "aac") {
        firstType = "audio";
        contentType = httpParser.MediaType("audio", type);
      } else {
        firstType = "image";
        contentType = httpParser.MediaType("image", type);
      }
      print(contentType.mimeType);
      var multipartFile;
      if (type == "mp4") {
        var videoStream = http.ByteStream(Stream.castFrom(file.openRead()));

        // Get the file length
        var videoLength = await file.length();

        // Create a multipart file from the video stream
        multipartFile = http.MultipartFile(
          'video',
          videoStream,
          videoLength,
          filename: file.path.split('/').last,
          contentType: httpParser.MediaType('video', 'mp4'),
        );
      } else {
        var bytes = await tempFile.readAsBytes();
        multipartFile = http.MultipartFile.fromBytes(
          firstType,
          bytes,
          filename: tempFile.path.split('/').last,
          contentType: contentType,
        );
      }
      print(multipartFile);

      // print(multipartFile.contentType);
      request.files.add(multipartFile);
    }

    // Add additional data to the request
    request.fields['content'] = content;
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Add headers to the request
    request.headers.addAll(headers);
    return await http.Response.fromStream(await request.send());
  }

  static Future addNewPostUsingDio(
      {required List<dynamic> files,
      required String path,
      required String content,
      required String token}) async {
    var url = '${Constants.baseUrl}$path'; // Replace with your server URL

    var dio = Dio();

    var formData = FormData();
    formData.fields.add(MapEntry("content", content));

    for (int i = 0; i < files.length; i++) {
      var file = files[i];
      httpParser.MediaType? contentType;
      final type = file.path.split('/').last.toString().split('.')[1];
      if (type == "mp4") {
        contentType = httpParser.MediaType("video", type);
      } else if (type == "aac") {
        contentType = httpParser.MediaType("audio", type);
      } else {
        contentType = httpParser.MediaType("image", type);
      }
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: contentType,
        ),
      ));
    }
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio.post(
      url,
      data: formData,
      options: Options(headers: headers),
    );
  }

  static Future getMyPosts({required int page, required String token}) async {
    final url = Uri.parse('${Constants.baseUrl}/post/byUser?page=$page');
    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }

  static Future deletePost({required int postId, required String token}) async {
    final url = Uri.parse('${Constants.baseUrl}/post/$postId');
    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }

  static Future editPost(
      {required Map<String, dynamic> editedPost,
      required String token}) async {}
}
