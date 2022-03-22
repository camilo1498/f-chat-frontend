import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/user.dart';

class ChatProvider extends ChangeNotifier{
  /// endpoint
  final String url = Environment.apiChat + 'api/chats';
  ApiResponse _apiResponse = ApiResponse();

  /// user model instance
  final User _user = User.fromJson(GetStorage().read('user') ?? {});
  /// Dio instance
  final Dio dio = Dio();
  /// loading
  bool _loading = false;

  bool get loading => _loading;

  Future<ApiResponse> create(Chat chat) async{
    try{
      _loading = true;
      notifyListeners();
      Response _res = await dio.post(
          '$url/create',
          data: chat.toJson(),
          options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization': _user.sessionToken!
              }
          )
      );
      _apiResponse = ApiResponse.fromJson(_res.data);

      if(_apiResponse.success == true){
        return _apiResponse;
      } else{
        return _apiResponse;
      }
    } on DioError catch(err){
      _apiResponse = ApiResponse.fromJson(err.response!.data);
      return _apiResponse;
    } finally{
      _loading = false;
      notifyListeners();
    }
  }

}