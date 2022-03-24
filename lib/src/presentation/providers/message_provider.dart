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



  /// message list
  List<Message> _message = [];
  List<Message> get message => _message;
  set message(List<Message> message){
    _message = message;
    notifyListeners();
  }

  /// message id
  String _messageId = '';
  String get messageId => _messageId;
  set messageId(String id){
    _messageId = id;
    notifyListeners();
  }

  /// is user online
  bool _isOnline = false;
  bool get isOnline => _isOnline;
  set isOnline(bool online){
    _isOnline = online;
    notifyListeners();
  }

  /// is user writing
  bool _isWriting = false;
  bool get isWriting => _isWriting;
  set isWriting(bool writing){
    _isWriting = writing;
    notifyListeners();
  }
  /// chat id
  String _chatId = '';
  String get chatId => _chatId;
  set chatId(String id){
    _chatId = id;
    notifyListeners();
  }

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
  Future<List<Message>> getMessagesByChat() async{
    try{
      _loading = true;
      notifyListeners();
      /// send req to server
      Response _res = await dio.get(
          '$url/findByChat/$chatId',
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
        List<Message> _message = Message.fromJsonList(_res.data);
        return _message;
      } else{
        showToast(message: _res.data);
        return [];
      }

    } on DioError catch (err){
      debugPrint(err.response!.data);
      return [];
    } finally{
      _loading = false;
      notifyListeners();
    }

  }

  /// update seen message
  Future<ApiResponse> updateToSeen({required String messageId}) async{
    try{
      /// req to server
      Response _res = await dio.put(
        '$url/updateToSeen',
        data: {
          'id': messageId
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': _user.sessionToken!
          }
        )
      );
      _apiResponse = ApiResponse.fromJson(_res.data);
      /// validate response
      if(_apiResponse.success == true){
        return _apiResponse;
      } else{
        debugPrint(_apiResponse.message);
        return _apiResponse;
      }
    } on DioError catch(err){
      _apiResponse = ApiResponse.fromJson(err.response!.data);
      debugPrint(_apiResponse.message);
      return _apiResponse;
    } finally{
      notifyListeners();
    }
  }

  /// update ro received message
  Future<ApiResponse> updateToReceived({required String messageId}) async{
    try{
      /// req to server
      Response _res = await dio.put(
          '$url/updateToReceived',
          data: {
            'id': messageId
          },
          options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization': _user.sessionToken!
              }
          )
      );
      _apiResponse = ApiResponse.fromJson(_res.data);
      /// validate response
      if(_apiResponse.success == true){
        return _apiResponse;
      } else{
        debugPrint(_apiResponse.message);
        return _apiResponse;
      }
    } on DioError catch(err){
      _apiResponse = ApiResponse.fromJson(err.response!.data);
      debugPrint(_apiResponse.message);
      return _apiResponse;
    } finally{
      notifyListeners();
    }
  }

}