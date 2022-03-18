import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider extends ChangeNotifier {
  /// endpoint
  final String url = Environment.apiChat + 'api/users';
  ApiResponse _apiResponse = ApiResponse();

  /// user model instance
  User _user = User.fromJson(GetStorage().read('user') ?? {});

  /// loading
  bool _loading = false;

  /// Dio instance
  final Dio dio = Dio();

  /// getter
  bool get loading => _loading;
  User get user => _user;
  ApiResponse get apiResponse => _apiResponse;

  set apiResponse(ApiResponse res) {
    _apiResponse = res;
    notifyListeners();
  }

  Future<ApiResponse> updateUserInfo({required User user, File? image}) async {
    try {
      _loading = true;
      notifyListeners();
      if (image != null) {
        /// update with image
        FormData form = FormData.fromMap({
          'image':
              await MultipartFile.fromFile(image.path, filename: user.email),
          'user': json.encode(user)
        });
        Response _res = await dio.put(
          '$url/updateWithImage',
          data: form,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': user.sessionToken!
          }),
        );
        apiResponse = ApiResponse.fromJson(_res.data);
        if (apiResponse.success == true) {
          User userRes = User.fromJson(apiResponse.data);
          GetStorage().write('user', userRes.toJson());
          notifyListeners();
          _user = userRes;
          return apiResponse;
        } else {
          return apiResponse;
        }
      } else {
        /// update without image
        Response _res = await dio.put(
          '$url/update',
          data: user.toJson(),
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': user.sessionToken!
          }),
        );

        apiResponse = ApiResponse.fromJson(_res.data);
        if (apiResponse.success == true) {
          User userRes = User.fromJson(apiResponse.data);
          GetStorage().write('user', userRes.toJson());
          notifyListeners();
          _user = userRes;
          return apiResponse;
        } else {
          return apiResponse;
        }
      }
    } on DioError catch (err) {
      return ApiResponse(
        success: false,
        message: err.message,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
