
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/providers/sound_recorder.dart';

import '../components/response/handle_response_msg.dart';
import '../models/community_model.dart';
import '../models/current_user.dart';
import '../utils/check_internet_connection.dart';
import 'package:mime/mime.dart';

import '../view_model/community_view_model.dart';
import '../view_model/post_comments_view_model.dart';

enum FileType { record, attach }

class AddPostOrCommentToCommunity with ChangeNotifier {
  bool isLoading = false;

  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  final recorder = SoundRecorder();
  final Map<String, dynamic> uploads = {
    "content": "",
    "attaches": [],
    "records": []
  };

  bool isRecording = false;

  void notifyRecord() {
    isRecording = !isRecording;
    notifyListeners();
  }

  void clearUploads() {
    uploads['attaches']!.clear();
    uploads['records']!.clear();
    notifyListeners();
  }

  void deleteFile({required int index, required FileType fileType}) {
    if (fileType == FileType.attach) {
      uploads['attaches']!.removeAt(index);
    } else {
      uploads['records']!.removeAt(index);
    }
    notifyListeners();
  }

  Future uploadFile({required FileType fileType, BuildContext? context}) async {
    if (fileType == FileType.attach) {
      await _uploadAttachFile(context!);
    } else {
      await _recording(context!);
    }
  }

  String _getFileType(String filePath) {
    final mimeType = lookupMimeType(filePath);

    if (mimeType?.startsWith('image') == true) {
      return 'image';
    } else if (mimeType?.startsWith('video') == true) {
      return 'video';
    } else {
      return 'unknown';
    }
  }

  Future _uploadAttachFile(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultipleMedia();
      if(pickedFiles.length > 10 || (pickedFiles.length + uploads['attaches'].length > 10)){
        HandleResponseMsg.showSnackBar(context: context, msg: 'maxNumberOfPickedFiles', statusCode: 400);
        return;
      }
      for (final file in pickedFiles) {
        final fileType = _getFileType(file.path);
        if (fileType == 'unknown') {
          // ignore: use_build_context_synchronously
          HandleResponseMsg.showSnackBar(
            context: context,
            msg: "onlyImagesOrVideos",
            statusCode: 400,
          );
          return;
        }
      }
      uploads['attaches']!.addAll(pickedFiles);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future addNewPostOrComment(
      {required BuildContext context,
      required String content,
      required String path}) async {
        if(content == "" && uploads['attaches'].length == 0 && uploads['records'].length == 0){
          HandleResponseMsg.showSnackBar(context: context, msg: 'pleaseAddAtLeaseContent', statusCode: 400);
          return;
        }
    _notify();
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      uploads['content'] = content;
      final filesProvider = uploads;

      final List<dynamic> files = List.from(filesProvider['attaches'])
        ..addAll(filesProvider['records']);

      final Response<dynamic> response =
          await CommunityModel.addNewPostUsingDio(
        files: files,
        content: filesProvider['content'],
        token: userToken,
        path: path,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      print(response);
      // ignore: use_build_context_synchronously
      HandleResponseMsg.showSnackBar(
        context: context,
        msg: "postUploadedSuccessfully",
        statusCode: response.statusCode!,
      );
      final Map<String, dynamic> newPost = {
        "content": "",
        "createdAt": "",
        "user": {}
        
      };
      final String type = path.contains("post") ? "post" : "comment";
      final responseData = response.data;
      print(responseData);
      if (type == "post") {
        newPost.putIfAbsent("uploads", () => responseData['files']);
        newPost.putIfAbsent("id", () => responseData[type]['id']);
        newPost.putIfAbsent("comments", () => []);
      } else {
        newPost.putIfAbsent("uploadComments", () => responseData['files']);
      }
      newPost["content"] = responseData[type]['content'];
      newPost['user'] = responseData['user'];
      newPost['createdAt'] = responseData[type]['createdAt'];
      print(newPost);
      if (type == "post") {
        Provider.of<CommunityViewModel>(context, listen: false)
            .addNewPost(post: newPost);
      } else {
        Provider.of<PostCommentsViewModel>(context, listen: false)
            .addNewComment(comment: newPost);
      }
      clearUploads();
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Future _recording(BuildContext context) async {
    try {
      await recorder.toggleRecording(context);
    } catch (err) {
      print(err);
    }
  }
}
