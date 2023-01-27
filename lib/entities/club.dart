import 'package:mvc_pattern/mvc_pattern.dart';

class Club extends ModelMVC {
  factory Club([StateMVC? state]) => _this ??= Club._(state);
  Club._(StateMVC? state) : super(state);
  static Club? _this;

  String name = "";
  int apiId = 0;

  Club? newClub(String name, int apiId) {
    this.name = name;
    this.apiId = apiId;
  }

  String get getName {
    return name;
  }

  set setName(String newName) {
    name = newName;
  }

  int get getApiId {
    return apiId;
  }

  set setApiId(int newApiId) {
    apiId = newApiId;
  }
}
