import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:table_calendar_example/controller/cafe_information_controller.dart';
import 'package:table_calendar_example/page/menu_information_page.dart';
import '../ui/colors.dart' as colors;

CafeInformationController cafeInformationController =
    Get.put(CafeInformationController());

class CafeInformationSetting extends StatefulWidget {
  @override
  _CafeInformationSettingState createState() => _CafeInformationSettingState();
}

class _CafeInformationSettingState extends State<CafeInformationSetting>
    with SingleTickerProviderStateMixin {
  final _cafeNameController = cafeInformationController.cafeNameController;
  final _cafeIntroController = cafeInformationController.cafeIntroController;
  final _cafeLocationController =
      cafeInformationController.cafeLocationController;
  final Map<int, TextEditingController> _tableNameController =
      cafeInformationController.tableNameControllers;

  Map<String, Map<String, dynamic>> _menu = cafeInformationController.menu;
  int _currentTap;
  List _categoryIsSelected;
  String _size;
  String _oz;
  Map<String, int> _cupSize = cafeInformationController.cupSize;

  List<Widget> _cafeImages(List _images) {
    return List.generate(_images.length, (index) {
      Asset asset = _images[index];
      return AssetThumb(
        asset: asset,
        width: 150,
        height: 150,
      );
    });
  }

  Future<void> _loadCafeAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: cafeInformationController.cafeIntroimages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      cafeInformationController.cafeIntroimages = resultList;
    });
  }

  List<String> categoryName;
  List<dynamic> categoryInfo;
  List<List> menuInfo;

  @override
  void initState() {
    categoryName = _menu == null ? [] : _menu.keys.toList(); //[coffee, desert]
    // TODO: implement initState

    _categoryIsSelected =
        List.filled(categoryName.length + 1, false, growable: true);
    _currentTap = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _asyncAddCategory(BuildContext context) async {
    String _categoryName = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter category'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Category', hintText: 'eg. juice'),
                onChanged: (value) {
                  _categoryName = value;
                },
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('cancel'),
              onPressed: () {
                Get.back();
              },
            ),
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  if (_menu.containsKey(_categoryName)) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert',
                                style: TextStyle(color: Colors.red)),
                            backgroundColor: colors.dojagoGreen2,
                            content: Text(
                              '$_categoryName은(는) 이미 존재하는 카테고리명 입니다.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    _menu.update(_categoryName, (v) => v, ifAbsent: () => {});
                    _categoryIsSelected.add(false);
                    Get.back();
                    setState(() {});
                  }
                }),
          ],
        );
      },
    );
  }

  Future _asyncEditCategory(BuildContext context, String name) async {
    String _categoryName = name;
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter category'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Category', hintText: _categoryName),
                onChanged: (value) {
                  _categoryName = value;
                },
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('cancel'),
              onPressed: () {
                Get.back();
              },
            ),
            FlatButton(
              child: Text('remove'),
              onPressed: () {
                Map _tmp =
                    Map.fromIterables(categoryName, categoryName.asMap().keys);
                _menu.remove(_categoryName);
                _categoryIsSelected.removeAt(_tmp[_categoryName]);
                Get.back();
                setState(() {});
              },
            ),
            FlatButton(
              child: Text('edit'),
              onPressed: () {
                Map<Map<String, dynamic>, String> _tmp =
                    Map.fromIterables(_menu.values, _menu.keys);
                var _tmpValue = _menu[name];
                _tmp[_tmpValue] = _categoryName;
                _menu = Map.fromIterables(_tmp.values, _tmp.keys);
                Get.back();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future _asyncEditMenu(
      BuildContext context, String category, String menu) async {
    String _menuName = menu;
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter menu'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration:
                    new InputDecoration(labelText: 'Menu', hintText: _menuName),
                onChanged: (value) {
                  _menuName = value;
                },
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('cancel'),
              onPressed: () {
                Get.back();
              },
            ),
            FlatButton(
              child: Text('remove'),
              onPressed: () {
                _menu[category].remove(_menuName);
                Get.back();
                setState(() {});
              },
            ),
            FlatButton(
              child: Text('edit'),
              onPressed: () {
                Map<dynamic, String> _tmp = Map.fromIterables(
                    _menu[category].values, _menu[category].keys);
                var _tmpValue = _menu[category][menu];
                _tmp[_tmpValue] = _menuName;
                _menu[category] = Map.fromIterables(_tmp.values, _tmp.keys);
                Get.back();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future _asyncAddMenu(BuildContext context, String category) async {
    String _menuName = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter menu'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Menu', hintText: 'eg. cake'),
                onChanged: (value) {
                  _menuName = value;
                },
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('cancel'),
              onPressed: () {
                Get.back();
              },
            ),
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  if (_menu[category].containsKey(_menuName)) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert',
                                style: TextStyle(color: Colors.red)),
                            backgroundColor: colors.dojagoGreen2,
                            content: Text(
                              '$_menuName은(는) 이미 존재하는 메뉴명 입니다.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    _menu[category]..addAll({_menuName: {}});

                    Get.back();
                    setState(() {});
                  }
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('카페 정보 설정'),
          bottom: TabBar(
            onTap: (value) {
              setState(() {
                _currentTap = value;
              });
            },
            tabs: [
              Tab(
                icon: Icon(Icons.settings),
                child: Text('settings'),
              ),
              Tab(icon: Icon(Icons.menu), child: Text('menu')),
            ],
          ),
        ),
        body: TabBarView(children: [
          settingPage(),
          menuPage(),
        ]),
      ),
    );
  }

  Widget menuPage() {
    categoryName = _menu == null ? [] : _menu.keys.toList(); //[coffee, desert]
    categoryInfo = _menu == null ? [] : _menu.values.toList();
    menuInfo = List.generate(categoryInfo.length, (i) {
      try {
        return categoryInfo[i].keys.toList();
      } catch (e) {
        print(e);
        return [];
      }
    }); //[[Americano, Latte], [케잌, 머핀, 마카롱, 크로아상]]

    return Column(children: [
      Container(color: Colors.orange,child: Column(children: [Padding(
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Row(
            children: [Expanded(
                child: Container(
                  color: Colors.green[200],
                  height: 30,
                  padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                  child: Text('매장에서 사용하는 음료 사이즈와 해당 oz를 입력해주세요.'),
                )),]
        ),
      ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: Container(color: Colors.green[200],
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      height: 60,
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: 'size',
                            hintText: 'grande',
                            border: OutlineInputBorder()),
                        onChanged: (v) => _size = v,
                      ),
                    )),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Container(
                      height: 60,
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: 'oz',
                            hintText: '17',
                            border: OutlineInputBorder()),
                        onChanged: (v) => v != '' ? _oz = v : null,
                      ),
                    )),
                SizedBox(
                  height: 60,
                  child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (_cupSize.containsKey(_size)) {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Alert',
                                      style: TextStyle(color: Colors.red)),
                                  backgroundColor: colors.dojagoGreen2,
                                  content: Text(
                                    '$_size은(는) 이미 존재하는 카테고리명 입니다.',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                        _cupSize[_size] = int.parse(_oz);
                        setState(() {});
                      }),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            color: Colors.green[200],
            height: _cupSize.length * 46.0,
            child: ListView(
              children: List.generate(
                  _cupSize.length,
                      (index) => Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                    child: Container(
                      height: 42,
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                '${_cupSize.keys.toList()[index]}',
                                style: TextStyle(fontSize: 18),
                              )),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: Text(
                                  '${_cupSize.values.toList()[index]}',
                                  style: TextStyle(fontSize: 18))),
                          IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                _cupSize
                                    .remove(_cupSize.keys.toList()[index]);
                                setState(() {});
                              })
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ),],),),
      Divider(
        height: 4,
        color: Colors.black,
      ),
      Expanded(
        flex: 2,
        child: GroupListView(
          sectionsCount: categoryName.length + 1,
          countOfItemInSection: (int section) {
            return (_categoryIsSelected[section] == true)
                ? (section != categoryName.length
                    ? menuInfo[section].length + 1
                    : 0)
                : 0;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Ink(
                color: colors.dojagoGreen,
                child: index.index != menuInfo[index.section].length
                    ? ListTile(
                        title: Text(
                          menuInfo[index.section][index.index],
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        onTap: () {
                          Get.to(() => MenuInformationSetting(), arguments: [
                            categoryName[index.section],
                            menuInfo[index.section][index.index]
                          ]);
                        },
                        onLongPress: () {
                          print('long pressed');
                          _asyncEditMenu(context, categoryName[index.section],
                              menuInfo[index.section][index.index]);
                        },
                      )
                    : ListTile(
                        title: Icon(Icons.add),
                        onTap: () {
                          _asyncAddMenu(context, categoryName[index.section]);
                        },
                      ),
              ),
            );
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Ink(
                color: colors.dojagoYello,
                child: categoryName.length != section
                    ? ListTile(
                        title: Text(
                          categoryName[section],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        onLongPress: () {
                          print('long pressed');
                          _asyncEditCategory(context, categoryName[section]);
                        },
                        trailing: _categoryIsSelected[section]
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_up),
                        onTap: () {
                          setState(() {
                            _categoryIsSelected[section] =
                                !_categoryIsSelected[section];
                          });
                        },
                      )
                    : ListTile(
                        title: Icon(Icons.add),
                        onTap: () {
                          _asyncAddCategory(context);
                        },
                      ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 1),
          sectionSeparatorBuilder: (context, section) => SizedBox(height: 2),
        ),
      ),
    ]);
  }

  Widget settingPage() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('카페명',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            TextField(
                controller: _cafeNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '카페명',
                )),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            Text('카페사진',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Container(
                color: colors.dojagoYello,
                height: 150,
                child: cafeInformationController.cafeIntroimages.length == 0
                    ? GestureDetector(
                        child: Center(child: Icon(Icons.add, size: 40)),
                        onTap: _loadCafeAssets,
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: _cafeImages(
                                cafeInformationController.cafeIntroimages)
                              ..add(GestureDetector(
                                child: Center(child: Icon(Icons.add, size: 40)),
                                onTap: _loadCafeAssets,
                              ))),
                      )),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            Text('카페소개',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Container(
              // color: colors.dojagoYello,
              child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _cafeIntroController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '카페 소개 글',
                  )),
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 12,
            ),
            Text('위치',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            TextField(
              controller: _cafeLocationController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '도로명 주소'),
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            Text('영업시간',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                cafeInformationController.openTime == null
                    ? RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          '오픈 시간',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          // 여기서 사용자가 시간을 선택할 때까지 코드가 블록됨.
                          selectedTime.then((timeOfDay) {
                            setState(() {
                              cafeInformationController.openTime =
                                  '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
                            });
                          });
                        })
                    : Text(
                        'open: ${cafeInformationController.openTime}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                cafeInformationController.closeTime == null
                    ? RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)),
                        child: Text(
                          '마감 시간',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          // 여기서 사용자가 시간을 선택할 때까지 코드가 블록됨.
                          selectedTime.then((timeOfDay) {
                            setState(() {
                              cafeInformationController.closeTime =
                                  '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
                            });
                          });
                        })
                    : Text(
                        'close: ${cafeInformationController.closeTime}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
              ],
            ),
            Text('주차장 유무',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Checkbox(
              value: cafeInformationController.carParking, //처음엔 false
              onChanged: (value) {
                //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                setState(() {
                  cafeInformationController.carParking = value; //true가 들어감.
                });
              },
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('좌석 수',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                NumberPicker.horizontal(
                    listViewHeight: 40,
                    initialValue: cafeInformationController.numberOfTable,
                    minValue: 1,
                    maxValue: 10,
                    onChanged: (newValue) => setState(() =>
                        cafeInformationController.numberOfTable = newValue)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            Text('자리 사진',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Column(
              children: _tableImages(cafeInformationController.numberOfTable),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tableImages(int numberOfTable) {
    return List.generate(numberOfTable, (index) {
      _tableNameController[index + 1] = TextEditingController(
          text: cafeInformationController
                      .tableNameControllers[index + 1].text ==
                  null
              ? '좌석 ${index + 1}'
              : cafeInformationController.tableNameControllers[index + 1].text);
      Widget column = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('좌석 ${index + 1}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            TextField(
                controller: _tableNameController[index + 1],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '좌석 이름',
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '최대 착석 가능 인원',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                NumberPicker.horizontal(
                    listViewHeight: 40,
                    initialValue: cafeInformationController
                                .tablePerPeople[index + 1] ==
                            null
                        ? 1
                        : cafeInformationController.tablePerPeople[index + 1],
                    minValue: 1,
                    maxValue: 4,
                    onChanged: (newValue) => setState(() =>
                        cafeInformationController.tablePerPeople[index + 1] =
                            newValue)),
              ],
            ),
            Container(
              color: colors.dojagoYello,
              height: 150,
              child: (cafeInformationController.tablePerImages[index + 1] ==
                          null) ||
                      (cafeInformationController
                              .tablePerImages[index + 1].length ==
                          0)
                  ? GestureDetector(
                      child: Center(child: Icon(Icons.add, size: 40)),
                      onTap: () {
                        _loadTableAssets(index + 1);
                      })
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _eachTableImages(cafeInformationController
                              .tablePerImages[index + 1])
                            ..add(
                              GestureDetector(
                                  child:
                                      Center(child: Icon(Icons.add, size: 40)),
                                  onTap: () {
                                    _loadTableAssets(index + 1);
                                  }),
                            ))),
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
          ]);
      cafeInformationController.tableNameControllers = _tableNameController;
      return column;
    });
  }

  List<Widget> _eachTableImages(List _images) {
    return List.generate(_images.length, (index) {
      Asset asset = _images[index];
      return AssetThumb(
        asset: asset,
        width: 150,
        height: 150,
      );
    });
  }

  Future<void> _loadTableAssets(int i) async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: cafeInformationController.tablePerImages[i] == null
            ? []
            : cafeInformationController.tablePerImages[i],
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return [];

    setState(() {
      cafeInformationController.tablePerImages[i] = resultList;
    });
  }
}
