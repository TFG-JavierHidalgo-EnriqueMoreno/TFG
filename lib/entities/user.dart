import 'package:http/http.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class User extends ModelMVC {
  factory User([StateMVC? state]) => _this ??= User._(state);
  User._(StateMVC? state) : super(state);
  static User? _this;

  String username = "";
  String password = "";
  String name = "";
  String phone = "";
  String email = "";
  int elo = 0;
  String status = "";
  int tokens = 0;

  User? newUser(String username, String password, String name, String phone,
      String email, int elo, String status, int tokens) {
    this.username = username;
    this.password = password;
    this.name = name;
    this.phone = phone;
    this.email = email;
    this.elo = elo;
    this.status = status;
    this.tokens = tokens;
  }

  String get getUsername {
    return username;
  }

  String get getPassword {
    return password;
  }

  String get getName {
    return name;
  }

  String get getPhone {
    return phone;
  }

  String get getEmail {
    return email;
  }

  int get getElo {
    return elo;
  }

  String get getStatus {
    return status;
  }

  int get getTokens {
    return tokens;
  }

  set setUsername(String newUsername) {
    username = newUsername;
  }

  set setPassword(String newPassword) {
    password = newPassword;
  }

  set setName(String newName) {
    name = newName;
  }

  set setPhone(String newPhone) {
    phone = newPhone;
  }

  set setEmail(String newEmail) {
    email = newEmail;
  }

  set setElo(int newElo) {
    elo = newElo;
  }

  set setStatus(String newStatus) {
    status = newStatus;
  }

  set setTokens(int newTokens) {
    tokens = newTokens;
  }
}
