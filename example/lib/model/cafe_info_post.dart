import 'dart:io';

class CafeInfoPost {
  final String cafeName;
  final List<File> cafeImage;
  final String cafeIntro;
  final String cafeLocation;
  final DateTime openTime;
  final DateTime closeTime;
  final bool parkingLot;
  final int numberOfTables;
  final Map<int, List<File>> tablePerImages;
  final Map<int, String> tableName;
  final Map<int, int> tablePerPeople;

  CafeInfoPost({
    this.cafeName,
    this.cafeImage,
    this.cafeIntro,
    this.cafeLocation,
    this.openTime,
    this.closeTime,
    this.parkingLot,
    this.numberOfTables,
    this.tablePerImages,
    this.tableName,
    this.tablePerPeople,
  });

  factory CafeInfoPost.fromJSON(Map<String, dynamic> json) {
    return CafeInfoPost(
      cafeName: json['cafeName'],
      cafeImage: json['cafeImage'],
      cafeIntro: json['cafeIntro'],
      cafeLocation: json['cafeLocation'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      parkingLot: json['parkingLot'],
      numberOfTables: json['numberOfTables'],
      tablePerImages: json['tablePerImages'],
      tableName: json['tableName'],
      tablePerPeople: json['tablePerPeople'],
    );
  }

  Map<String, dynamic> toJson() => {
        "cafeName": cafeName,
        "cafeImage": cafeImage,
        "cafeIntro": cafeIntro,
        "cafeLocation": cafeLocation,
        "openTime": openTime,
        "closeTime": closeTime,
        "parkingLot": parkingLot,
        "numberOfTables": numberOfTables,
        "tablePerImages": tablePerImages,
        "tableName": tableName,
        "tablePerPeople": tablePerPeople,
      };
}

class MenuInfoPost {}

class BeverageInfo {}

class DesertInfo {}

Map _test = {
  "data": [
    {
      "large category": "beverage",
      "small category": "coffee",
      "menu":"Americano(R)",
      "mainMenu":false,
      "bean":["콜롬비아","케냐"],
      "ice": 1800,
      "hot": 1500,
      "syrup":["바닐라","헤이즐넛","카라멜"],
      "decaffein": false,
      "image": null
    },
    {
      "large category": "beverage",
      "small category": "coffee",
      "menu":"Americano(L)",
      "mainMenu":false,
      "bean":["콜롬비아","케냐"],
      "ice": 2300,
      "hot": 2000,
      "syrup":["바닐라","헤이즐넛","카라멜"],
      "decaffein": false,
      "image": null
    },
    {
      "large category": "beverage",
      "small category": "coffee",
      "menu":"Latte(R)",
      "mainMenu":false,
      "bean":["콜롬비아","케냐"],
      "ice": 2300,
      "hot": 2000,
      "syrup":["바닐라","헤이즐넛","카라멜"],
      "decaffein": false,
      "image": null
    },
    {
      "large category": "beverage",
      "small category": "coffee",
      "menu":"Latte(L)",
      "mainMenu":false,
      "bean":["콜롬비아","케냐"],
      "ice": 2800,
      "hot": 2300,
      "syrup":["바닐라","헤이즐넛","카라멜"],
      "decaffein": false,
      "image": null
    },
    {
      "large category": "desert",
      "small category": "desert",
      "menu":"cake",
      "mainMenu":true,
      "bean":null,
      "ice": 4000,
      "hot": null,
      "syrup":null,
      "decaffein": null,
      "image": null
    }
  ]
};