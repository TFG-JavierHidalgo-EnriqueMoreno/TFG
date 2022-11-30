import 'package:flutter/scheduler.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:my_app/entities/EditData.dart';

import '../entities/user.dart';
import '../entities/users.dart';

class userController extends ControllerMVC {
  factory userController([StateMVC? state]) =>
      _this ??= userController._(state);
  userController._(StateMVC? state)
      : _model = User(),
        super(state);
  static userController? _this;

  final User _model;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.name)) {
        return 'El Usuario no existe';
      }
      if (mockUsers[data.name] != data.password) {
        return 'Contraseña incorrecta';
      }
      return null;
    });
  }

  Future<String?> signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'El Usuario no existe';
      }
      return null;
    });
  }

  Future<String?> signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> editConfirm(String error, EditData data) {
    return Future.delayed(loginTime).then((value) => null);
  }
}
