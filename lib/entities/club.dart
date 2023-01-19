import 'package:mvc_pattern/mvc_pattern.dart';

class Club extends ModelMVC {
  factory Club([StateMVC? state]) => _this ??= Club._(state);
  Club._(StateMVC? state) : super(state);
  static Club? _this;

  String name = "";

  Club? newClub(String name) {
    this.name = name;
  }

  String get getName {
    return name;
  }

  set setName(String newName) {
    name = newName;
  }
}
