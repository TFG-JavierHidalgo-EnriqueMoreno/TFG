import 'package:quiver/core.dart';

class EditData {
  final String name;
  final String password;
  final String surname;
  final String phone;
  final String email;
  EditData(
      {required this.name,
      required this.password,
      required this.surname,
      required this.phone,
      required this.email});

  @override
  String toString() {
    return 'EditData($name, $password, $surname, $phone, $email)';
  }

  @override
  bool operator ==(Object other) {
    if (other is EditData) {
      return name == other.name &&
          password == other.password &&
          surname == other.surname &&
          phone == other.phone &&
          email == other.email;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(name, password, surname, phone, email);
}
