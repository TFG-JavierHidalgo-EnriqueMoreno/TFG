import 'package:mvc_pattern/mvc_pattern.dart';

class Lineup extends ModelMVC {
  factory Lineup([StateMVC? state]) => _this ??= Lineup._(state);
  Lineup._(StateMVC? state) : super(state);
  static Lineup? _this;

  String localLineup = "";
  String awayLineup = "";

  Lineup? newLineup(String localLineup, String awayLineup) {
    this.localLineup = localLineup;
    this.awayLineup = awayLineup;
  }

  String get getLocalLineup {
    return localLineup;
  }

  String get getAwayLineup {
    return awayLineup;
  }


  set setLocalLineup(String newlocalLineup) {
    localLineup = newlocalLineup;
  }

  set setAwayLineup(String newAwayLineups) {
    awayLineup = newAwayLineups;
  }

}
