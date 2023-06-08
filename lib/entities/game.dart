import 'package:mvc_pattern/mvc_pattern.dart';

class Game extends ModelMVC {
  factory Game([StateMVC? state]) => _this ??= Game._(state);
  Game._(StateMVC? state) : super(state);
  static Game? _this;

  int awayGoals = 0;
  int localGoals = 0;

  Game? newGame(int awayGoals, int localGoals) {
    this.awayGoals = awayGoals;
    this.localGoals = localGoals;
  }

  int get getAwayGoals {
    return awayGoals;
  }

  int get getLocalGoals {
    return localGoals;
  }
  
  set setAwayGoals(int newAwayGoals) {
    awayGoals = newAwayGoals;
  }

  set setLocalGoals(int newLocalGoals) {
    localGoals = newLocalGoals;
  }
}
