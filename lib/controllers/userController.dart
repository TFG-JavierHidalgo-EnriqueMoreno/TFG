import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:my_app/entities/EditData.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/screens/home_page.dart';
import 'package:my_app/screens/login_page.dart';
import 'package:my_app/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:my_app/entities/user.dart';
import 'package:my_app/entities/users.dart';
import 'package:my_app/entities/globals.dart' as globals;

class userController extends ControllerMVC {
  factory userController([StateMVC? state]) =>
      _this ??= userController._(state);
  userController._(StateMVC? state)
      : _model = User(),
        super(state);
  static userController? _this;

  final User _model;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> loginUser(LoginData data) async {
    Future<List> users = getUsers();

    Map<String, String> mapUser = new HashMap();

    List list = await users;

    list.forEach((user) {
      mapUser.putIfAbsent(
          user["data"]["email"], () => user["data"]["password"]);
    });

    return Future.delayed(loginTime).then((_) async {
      if (!mapUser.containsKey(data.name)) {
        return 'El Usuario no existe';
      }
      if (mapUser[data.name] != data.password) {
        return 'Contraseña incorrecta';
      }

      globals.isLoggedIn = true;

      var u =
          list.firstWhere((element) => element["data"]["email"] == data.name);
      globals.userLoggedIn.newUser(
          u["data"]["username"],
          u["data"]["password"],
          u["data"]["name"],
          u["data"]["phone"],
          u["data"]["email"],
          u["data"]["elo"]);

      globals.userLevel.newLevel(u["level"]["name"]);
      return null;
    });
  }

  Future<String?> signupUser(BuildContext context, SignupData data) async {
    // Guardar usuario en la BD

    Future<List> users = getUsers();

    List<String> listUser = [];

    List list = await users;

    list.forEach((user) {
      listUser.add(user["data"]["email"]);
    });

    if (!listUser.contains(data.name)) {
      String? email = data.name;
      String? password = data.password;
      String? phone = data.additionalSignupData?["phone_number"];
      String? username = data.additionalSignupData?["Username"];
      String? name = data.additionalSignupData?["Nombre"];
      String? surname = data.additionalSignupData?["Apellidos"];

      saveUser(email, password, phone, username, name, surname).then((_) {
        setState(() {});
      });
      return null;
    } else {
      return 'El Usuario ya existe';
    }
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
