import 'package:mvc_pattern/mvc_pattern.dart';

class Level extends ModelMVC {
  factory Level([StateMVC? state]) => _this ??= Level._(state);
  Level._(StateMVC? state) : super(state);
  static Level? _this;

  String name = "";
  int teamValue = 0;

  Level? newLevel(String name, int teamValue) {
    this.name = name;
    this.teamValue = teamValue;
  }

  String get getName {
    return name;
  }

  int get getTeamValue {
    return teamValue;
  }

  set setName(String newName) {
    name = newName;
  }

  set setTeamValue(int newTeamValue) {
    teamValue = teamValue;
  }
}
