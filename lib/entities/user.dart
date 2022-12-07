import 'package:mvc_pattern/mvc_pattern.dart';

class User extends ModelMVC {
  factory User([StateMVC? state]) => _this ??= User._(state);
  User._(StateMVC? state) : super(state);
  static User? _this;

  String username = "";
  String password = "";
  String name = "";
  String surname = "";
  String phone = "";
  String email = "";
  int elo = 0;

  // User(String username, String password, String name, String surname, String phone,
  //     String email, int elo) {
  //   this.username = username;
  //   this.password = password;
  //   this.name = name;
  //   this.surname = surname;
  //   this.phone = phone;
  //   this.email = email;
  //   this.elo = elo;
  // }

  String get getUsername {
    return username;
  }

  String get getPassword {
    return password;
  }

  String get getName {
    return name;
  }

  String get getSurname {
    return surname;
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

  set setUsername(String newUsername) {
    username = newUsername;
  }

  set setPassword(String newPassword) {
    password = newPassword;
  }

  set setName(String newName) {
    name = newName;
  }

  set setSurname(String newSurname) {
    surname = newSurname;
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
}
