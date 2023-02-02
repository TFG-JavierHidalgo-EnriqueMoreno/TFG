import 'package:mvc_pattern/mvc_pattern.dart';

class Country extends ModelMVC {
  factory Country([StateMVC? state]) => _this ??= Country._(state);
  Country._(StateMVC? state) : super(state);
  static Country? _this;

  String name = "";
  int apiId = 0;

  Country? newCountry(String name, int apiId) {
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
