import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MessageProvider extends ChangeNotifier{
  /// endpoint
  final String url = Environment.apiChat + 'api/messages';
  ApiResponse _apiResponse = ApiResponse();

  /// user model instance
  final User _user = User.fromJson(GetStorage().read('user') ?? {});
  /// Dio instance
  final Dio dio = Dio();
  /// loading
  bool _loading = false;

  bool get loading => _loading;

  /// create message
  Future<ApiResponse> create(Message message) async{
    try{
      _loading = true;
      notifyListeners();
      Response _res = await dio.post(
          '$url/create',
          data: message.toJson(),
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
      print(err.response!.data);
      _apiResponse = ApiResponse.fromJson(err.response!.data);
      return _apiResponse;
    } finally{
      _loading = false;
      notifyListeners();
    }
  }

  /// get messages
  Future<List<Message>> getMessagesByChat({required String chatId}) async{
    try{
      _loading = true;
      notifyListeners();
      /// send req to server
      Response _res = await dio.get(
          '$url/findByChat/${_user.id}',
          options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization': _user.sessionToken!
              }
          )
      );
      //apiResponse = ApiResponse.fromJson(_res.data); => fix response structure in backend
      if(_res.statusCode == 201){

        /// create list<User>
        List<User> _users = User.fromJsonList(_res.data);
        return [];
      } else{
        showToast(message: _res.data);
        return [];
      }

    } on DioError catch (err){
      _apiResponse = ApiResponse.fromJson(err.response!.data);
      return [];
    } finally{
      _loading = false;
      notifyListeners();
    }

  }

}