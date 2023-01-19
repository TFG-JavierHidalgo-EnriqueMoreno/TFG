import 'package:mvc_pattern/mvc_pattern.dart';

class Player extends ModelMVC {
  factory Player([StateMVC? state]) => _this ??= Player._(state);
  Player._(StateMVC? state) : super(state);
  static Player? _this;

  String name = "";
  String position = "";
  int rating = 0;
  int defense = 0;
  int dribbling = 0;
  int passing = 0;
  int shooting = 0;
  int speed = 0;
  int strength = 0;

  Player? newPlayer(String name, String position, int rating, int defense,
      int dribbling, int passing, int shooting, int speed, int strength) {
    this.name = name;
    this.position = position;
    this.rating = rating;
    this.defense = defense;
    this.dribbling = dribbling;
    this.passing = passing;
    this.shooting = shooting;
    this.speed = speed;
    this.strength = strength;
  }

  String get getName {
    return name;
  }

  String get getPosition {
    return position;
  }

  int get getRating {
    return rating;
  }

  int get getDefense {
    return defense;
  }

  int get getDribbling {
    return dribbling;
  }

  int get getPassing {
    return passing;
  }

  int get getShooting {
    return shooting;
  }

  int get getSpeed {
    return speed;
  }

  int get getStrength {
    return strength;
  }

  set setName(String newName) {
    name = newName;
  }

  set setPosition(String newPosition) {
    position = newPosition;
  }

  set setRating(int newRating) {
    rating = newRating;
  }

  set setDefense(int newDefense) {
    defense = newDefense;
  }

  set setDribbling(int newDribbling) {
    dribbling = newDribbling;
  }

  set setPassing(int newPassing) {
    passing = newPassing;
  }

  set setShooting(int newShooting) {
    shooting = newShooting;
  }

  set setSpeed(int newSpeed) {
    speed = newSpeed;
  }

  set setStrength(int newStrength) {
    strength = newStrength;
  }
}
