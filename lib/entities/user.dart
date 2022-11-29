import 'package:mvc_pattern/mvc_pattern.dart';

class User extends ModelMVC {
  factory User([StateMVC? state]) => _this ??= User._(state);
  User._(StateMVC? state) : super(state);
  static User? _this;

  String username = "";
  String password = "";
  String nombre = "";
  String apellidos = "";
  String telefono = "";
  String email = "";
  int elo = 0;

  // User(String username, String password, String nombre, String apellidos, String telefono,
  //     String email, int elo) {
  //   this.username = username;
  //   this.password = password;
  //   this.nombre = nombre;
  //   this.apellidos = apellidos;
  //   this.telefono = telefono;
  //   this.email = email;
  //   this.elo = elo;
  // }

  String get getUsername {
    return username;
  }

  String get getPassword {
    return password;
  }

  String get getNombre {
    return nombre;
  }

  String get getApellidos {
    return apellidos;
  }

  String get getTelefono {
    return telefono;
  }

  String get getEmail {
    return email;
  }

  int get getElo {
    return elo;
  }

  set setUsername(String nuevoUsername) {
    username = nuevoUsername;
  }

  set setPassword(String nuevoPassword) {
    password = nuevoPassword;
  }

  set setNombre(String nuevoNombre) {
    nombre = nuevoNombre;
  }

  set setApellidos(String nuevoApellidos) {
    apellidos = nuevoApellidos;
  }

  set setTelefono(String nuevoTelefono) {
    telefono = nuevoTelefono;
  }

  set setEmail(String nuevoEmail) {
    email = nuevoEmail;
  }

  set setElo(int nuevoElo) {
    elo = nuevoElo;
  }
}
