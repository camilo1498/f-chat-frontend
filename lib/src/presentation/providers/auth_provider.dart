import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _getUser();
  }

  /// endpoint
  final String url = Environment.apiChat + 'api/users';

  /// auth status
  AuthStatus _status = AuthStatus.uninitialized;

  /// user model instance
  final User _user = User();

  /// loading
  bool _loading = false;

  /// Dio instance
  final Dio dio = Dio();

  /// storage
  final GetStorage _storage = GetStorage();

  /// getter
  AuthStatus get status => _status;
  bool get loading => _loading;

  /// load user from device storage
  _getUser() {
    User user = User.fromJson(_storage.read('user') ?? {});
    if (user.id != null) {
      _status = AuthStatus.authenticated;
      notifyListeners();
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  /// create session
  Future<ApiResponse> login(
      {required String email, required String password}) async {
    try {
      _loading = true;
      notifyListeners();
      Response _res = await dio.post('$url/login',
          data: {'email': email, 'password': password},
          options: Options(headers: {'Content-Type': 'application/json'}));
      if (_res.statusCode == 201) {
        User _user = User.fromJson(_res.data['data']);
        _storage.write('user', _user.toJson());
        _getUser();
        ApiResponse apiResponse = ApiResponse.fromJson(_res.data);
        return apiResponse;
      } else {
        return  ApiResponse(
          message: 'Login error',
          success: false
        );
      }
    } on DioError catch (err) {
      _status = AuthStatus.unauthenticated;
      ApiResponse apiResponse = ApiResponse.fromJson(err.response!.data);
      return apiResponse;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// register user
  Future<ApiResponse> register({required User user}) async {
    try {
      _loading = true;
      notifyListeners();
      Response _res = await dio.post('$url/single-create',
          data: user.toJson(),
          options: Options(headers: {'Content-Type': 'application/json'}));

      if (_res.statusCode == 201) {
        var _login = await login(email: user.email!, password: user.password!);
        return _login;
      } else {
        return ApiResponse(
            message: 'Register error',
            success: false
        );
      }
    } on DioError catch (err) {
      _status = AuthStatus.unauthenticated;
      ApiResponse apiResponse = ApiResponse.fromJson(err.response!.data);
      return apiResponse;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// delete session
  logOut() async {
    await _storage.remove('user').then((value) {
      _getUser();
    });
  }
}
