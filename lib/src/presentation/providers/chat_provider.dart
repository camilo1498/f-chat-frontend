import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
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

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;
  set chats(List<Chat> chat){
    _chats = chat;
    notifyListeners();
  }

  Future<ApiResponse> create(Chat chat) async{
    try{
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
    } on DioError catch(err){;
      return ApiResponse(
        success: false,
        message: err.response!.data.toString()
      );
    } finally{
      notifyListeners();
    }
  }

  Future<List<Chat>> getChats() async{
    Response _res = await dio.get(
      '$url/findByIdUser/${_user.id}',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _user.sessionToken!
        }
      )
    );

    if(_res.statusCode == 201){
      List<Chat> chats = Chat.fromJsonList(_res.data);

      print(' chats => ${chats.length}');
      return chats;
    } else{
      showToast(message: _res.data);
      return [];
    }
  }
}