import 'package:mvc_pattern/mvc_pattern.dart';

class League extends ModelMVC {
  factory League([StateMVC? state]) => _this ??= League._(state);
  League._(StateMVC? state) : super(state);
  static League? _this;

  String name = "";

  League? newLeague(String name) {
    this.name = name;
  }

  String get getName {
    return name;
  }

  set setName(String newName) {
    name = newName;
  }
}
