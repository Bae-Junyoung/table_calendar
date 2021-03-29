import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:table_calendar_example/controller/cafe_information_controller.dart';
import './ui/colors.dart' as colors;

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

  Map<String, dynamic> _menu = cafeInformationController.menu;
  int _currentTap = 0;
  List _categoryIsSelected;

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
    categoryInfo = _menu == null ? [] : _menu.values.toList();
    menuInfo = List.generate(categoryInfo.length, (i) {
      try {
        return categoryInfo[i].keys.toList();
      } catch (e) {
        print(e);
        return [];
      }
    }); //[[Americano, Latte], [케잌, 머핀, 마카롱, 크로아상]]
    // TODO: implement initState

    _categoryIsSelected =
        List.filled(categoryName.length, true, growable: true);

    _fabAnimationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fabAnimationController);
    _buttonColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _fabAnimationController,
            curve: Interval(0.00, 1.00, curve: Curves.linear)));
    _translatedButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _fabAnimationController,
            curve: Interval(0.0, 0.75, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  bool _tapIsOpened = false;
  AnimationController _fabAnimationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translatedButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 48.0;

  Widget _buttonAdd() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blueAccent[400])),
      child: FloatingActionButton(
        onPressed: () {
          _asyncAddCategory(context);
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buttonEdit() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blueAccent[400])),
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Remove',
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buttonToggle() {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent[400])),
        child: FloatingActionButton(
          backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: 'Toggle',
          child: AnimatedIcon(
              icon: AnimatedIcons.menu_close, progress: _animationIcon),
        ));
  }

  animate() {
    if (!_tapIsOpened)
      _fabAnimationController.forward();
    else
      _fabAnimationController.reverse();
    _tapIsOpened = !_tapIsOpened;
  }

  Future _asyncAddCategory(BuildContext context) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter current team'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Category', hintText: 'eg. juice'),
                    onChanged: (value) {
                      teamName = value;
                    },
                  ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                _menu.update(teamName, (v) => v, ifAbsent: () => {});
                _categoryIsSelected.add(true);
                Get.back();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future _asyncEditCategory(BuildContext context) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter current team'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Category', hintText: 'eg. juice'),
                    onChanged: (value) {
                      teamName = value;
                    },
                  ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                _menu.update(teamName, (v) => v, ifAbsent: () => {});
                _categoryIsSelected.add(true);
                Get.back();
                setState(() {});
              },
            ),
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
        floatingActionButton: _currentTap != 1
            ? null
            : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Transform(
                transform: Matrix4.translationValues(
                    0.0, _translatedButton.value * 2.0, 0.0),
                child: _buttonAdd(),
              ),
              Transform(
                transform: Matrix4.translationValues(
                    0.0, _translatedButton.value * 1.0, 0.0),
                child: _buttonEdit(),
              ),
              _buttonToggle()
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
      Container(
        height: 100,
        color: Colors.red,
        child: Column(children: <Widget>[
          Text('HELP'),
          Text('우측 하단의 버튼으로 카테고리 추가'),
          Text('')
        ],),
      ),
      Expanded(
        child: GroupListView(
          sectionsCount: categoryName.length,
          countOfItemInSection: (int section) {
            return (_categoryIsSelected[section] == true)
                ? (menuInfo[section] != null ? menuInfo[section].length : 0)
                : 0;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Ink(
                color: colors.dojagoGreen,
                child: ListTile(
                  title: Text(
                    menuInfo[index.section][index.index],
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {},
                ),
              ),
            );
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Ink(
                color: colors.dojagoYello,
                child: ListTile(
                  title: Text(
                    categoryName[section],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  onLongPress: () {
                    print('long pressed');
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

