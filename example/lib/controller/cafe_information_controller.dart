import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SimpleMenuInfo {
  String category;
  String menuName;
  int price;

  SimpleMenuInfo(this.category, this.menuName, this.price);
}

class DetailMenuInfo {
  String category;
  String menuName;
  Map<String, Map> info;

  DetailMenuInfo(this.category, this.menuName, this.info);
}

class CafeInformationController extends GetxController {
  TextEditingController _cafeNameController =
      TextEditingController(text: 'doljago');
  TextEditingController _cafeIntroController = TextEditingController();
  TextEditingController _cafeLocationController = TextEditingController();
  List<Asset> _cafeIntroimages = <Asset>[];
  String _cafeIntro;
  String _cafeLocation;
  String _openTime = '08:00';
  String _closeTime = '20:00';
  bool _carParking = false;
  int _numberOfTable = 1;
  Map<int, List<Asset>> _tablePerImages = {1: []};
  Map<int, TextEditingController> _tableNameControllers = Map.fromIterable(
      List.generate(10, (index) => index),
      key: (v) => v,
      value: (v) => TextEditingController());
  Map<int, int> _tablePerPeople = {};

  Map<String, int> _cupSize = {};
  String _menuS = '''{
  "coffee": {
    "아메리카노": {
      "원두": {"0": "콜롬비아", "1": "케냐"},
      "hot": {
        "가격": {
          "regular": {"0": 16, "1": 1500},
          "venti": {"0": 20, "1": 2000}
        },
        "옵션": {"디카페인": false}
      },
      "ice": {
        "가격": {
          "regular": {"0": 16, "1": 1800},
          "venti": {"0": 20, "1": 2300}
        },
        "옵션": {"디카페인": false}
      }
    },
    "라떼": {
      "원두": {"0": "콜롬비아", "1": "케냐"},
      "hot": {
        "가격": {
          "regular": {"0": 16, "1": 2000},
          "venti": {"0": 20, "1": 2500}
        },
        "옵션": {"디카페인": false}
      },
      "ice": {
        "가격": {
          "regular": {"0": 16, "1": 2300},
          "venti": {"0": 20, "1": 2800}
        },
        "옵션": {"디카페인": false}
      }
    }
  },
  "desert": {
    "케잌": {"가격": 4000},
    "머핀": {"가격": 3000},
    "마카롱": {"가격": 2000},
    "크로아상": {"가격": 3000}
  }
}''';
  Map<String, Map<String, dynamic>> _menu = {
    "coffee": {
      "아메리카노": {
        "원두": {"0": "콜롬비아", "1": "케냐"},
        "hot": {
          "가격": {
            "regular": {"0": 1500, "1": 16},
            "venti": {"0": 2000, "1": 20}
          },
          "옵션": {"디카페인": false}
        },
        "ice": {
          "가격": {
            "regular": {"0": 1800, "1": 16},
            "venti": {"0": 2300, "1": 20}
          },
          "옵션": {"디카페인": false}
        }
      },
      "라떼": {
        "원두": {"0": "콜롬비아", "1": "케냐"},
        "hot": {
          "가격": {
            "regular": {"0": 2000, "1": 16},
            "venti": {"0": 2500, "1": 20}
          },
          "옵션": {"디카페인": false}
        },
        "ice": {
          "가격": {
            "regular": {"0": 2300, "1": 16},
            "venti": {"0": 2800, "1": 20}
          },
          "옵션": {"디카페인": false}
        }
      }
    },
    "desert": {
      "케잌": {"가격": 4000},
      "머핀": {"가격": 3000},
      "마카롱": {"가격": 2000},
      "크로아상": {"가격": 3000}
    }
  };

  TextEditingController get cafeNameController => _cafeNameController;

  TextEditingController get cafeIntroController => _cafeIntroController;

  TextEditingController get cafeLocationController => _cafeLocationController;

  List<Asset> get cafeIntroimages => _cafeIntroimages;

  String get cafeIntro => _cafeIntro;

  String get cafeLocation => _cafeLocation;

  String get openTime => _openTime;

  String get closeTime => _closeTime;

  bool get carParking => _carParking;

  int get numberOfTable => _numberOfTable;

  Map<int, List<Asset>> get tablePerImages => _tablePerImages;

  Map<int, TextEditingController> get tableNameControllers =>
      _tableNameControllers;

  Map<int, int> get tablePerPeople => _tablePerPeople;

  Map<String, Map<String, dynamic>> get menu => _menu;

  Map<String, int> get cupSize => _cupSize;

  set cafeIntroimages(List<Asset> cafeIntroimages) =>
      _cafeIntroimages = cafeIntroimages;

  set cafeIntro(String cafeIntro) => _cafeIntro = cafeIntro;

  set cafeLocation(String cafeLocation) => _cafeLocation = cafeLocation;

  set openTime(String openTime) => _openTime = openTime;

  set closeTime(String closeTime) => _closeTime = closeTime;

  set carParking(bool carParking) => _carParking = carParking;

  set numberOfTable(int numberOfTable) => _numberOfTable = numberOfTable;

  set tablePerImages(Map<int, List<Asset>> tablePerImages) =>
      _tablePerImages = tablePerImages;

  set tableNameControllers(
          Map<int, TextEditingController> tableNameControllers) =>
      _tableNameControllers = tableNameControllers;

  set tablePerPeople(Map<int, int> tablePerPeople) =>
      _tablePerPeople = tablePerPeople;

  set manu(Map<String, Map<String, dynamic>> menu) => _menu = menu;

  set cupSize(Map<String, int> cupSize) => _cupSize = cupSize;
}
