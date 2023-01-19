import 'package:mvc_pattern/mvc_pattern.dart';

class Level extends ModelMVC {
  factory Level([StateMVC? state]) => _this ??= Level._(state);
  Level._(StateMVC? state) : super(state);
  static Level? _this;

  String name = "";

  Level? newLevel(String name) {
    this.name = name;
  }

  String get getName {
    return name;
  }

  set setName(String newName) {
    name = newName;
  }

}
