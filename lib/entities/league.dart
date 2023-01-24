import 'package:mvc_pattern/mvc_pattern.dart';

class League extends ModelMVC {
  factory League([StateMVC? state]) => _this ??= League._(state);
  League._(StateMVC? state) : super(state);
  static League? _this;

  String name = "";
  int apiId = 0;

  League? newLeague(String name, int apiId) {
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
