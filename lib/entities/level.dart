import 'package:mvc_pattern/mvc_pattern.dart';

class Level extends ModelMVC {
  factory Level([StateMVC? state]) => _this ??= Level._(state);
  Level._(StateMVC? state) : super(state);
  static Level? _this;

  String name = "";
  int teamValue = 0;
  int numGolds = 0;
  int numSilvers = 0;
  int numBronzes = 0;

  Level? newLevel(String name, int teamValue, int numGolds, int numSilvers,
      int numBronzes) {
    this.name = name;
    this.teamValue = teamValue;
    this.numGolds = numGolds;
    this.numSilvers = numSilvers;
    this.numBronzes = numBronzes;
  }

  String get getName {
    return name;
  }

  int get getTeamValue {
    return teamValue;
  }

  int get getNumGolds {
    return numGolds;
  }

  int get getNumSilvers {
    return numSilvers;
  }

  int get getNumBronzes {
    return numBronzes;
  }

  set setName(String newName) {
    name = newName;
  }

  set setTeamValue(int newTeamValue) {
    teamValue = newTeamValue;
  }

  set setNumGolds(int newNumGolds) {
    numGolds = newNumGolds;
  }

  set setNumSilvers(int newNumSilvers) {
    numSilvers = newNumSilvers;
  }

  set setNumBronzes(int newNumBronzes) {
    numBronzes = newNumBronzes;
  }
}
