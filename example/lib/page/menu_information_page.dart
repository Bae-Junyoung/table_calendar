import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:table_calendar_example/controller/cafe_information_controller.dart';
import '../ui/colors.dart' as colors;
import 'cafe_information_setting_page.dart';

class MenuInformationSetting extends StatefulWidget {
  @override
  _MenuInformationSettingState createState() => _MenuInformationSettingState();
}

class _MenuInformationSettingState extends State<MenuInformationSetting> {
  List value = Get.arguments;

  Map<String, dynamic> _menuTmp = cafeInformationController.menu;

  int _menuType;

  Map<String, dynamic> map;
  bool _iceDecaf = false;
  bool _hotDecaf = false;
  String _chosenSize;
  Map<String, int> _cupSize = cafeInformationController.cupSize;
  String _bean;
  List _beans = List.generate(0, (index) => null, growable: true);

  @override
  void initState() {
    super.initState();
    _menuType = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${value[0]} - ${value[1]}'),
      ),
      backgroundColor: Colors.green[200],
      bottomSheet: Row(children: [
        Expanded(
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              height: 50,
              child: Center(child: Text('Save')),
            ),
            onTap: () {
              // _menu[value[0]][value[1]]
              // TODO: 입력받은 값을 _menu에 저장
              Get.back();
            },
          ),
        ),
      ]),
      body: SingleChildScrollView(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _menuType = 0;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.all(4.0),
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          color: _menuType == 0
                              ? Colors.yellow
                              : colors.dojagoYello,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                          child: Text(
                        '음료류',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )))),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _menuType = 1;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.all(4.0),
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          color: _menuType == 1
                              ? Colors.yellow
                              : colors.dojagoYello,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                          child: Text('디저트류',
                              style: TextStyle(fontWeight: FontWeight.bold))))),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _menuType = 2;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.all(4.0),
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          color: _menuType == 2
                              ? Colors.yellow
                              : colors.dojagoYello,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                          child: Text('기타',
                              style: TextStyle(fontWeight: FontWeight.bold))))),
            ],
          ),
        ),
        _menuType == 0 ? drink() : (_menuType == 1 ? desert() : etc()),
        Card(
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              Row(
                children: [Text('원두')],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: '원두',
                          hintText: '에콰도르',
                          border: OutlineInputBorder()),
                      onChanged: (v) {
                        _bean = v;
                      },
                    ),
                  )),
                  SizedBox(
                    height: 60,
                    child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if(_bean==null||_bean=='') {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Alert',
                                        style: TextStyle(color: Colors.red)),
                                    backgroundColor: colors.dojagoGreen2,
                                    content: Text(
                                      '원두를 입력해주세요.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                });}
                          else if (_beans.contains(_bean)) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Alert',
                                        style: TextStyle(color: Colors.red)),
                                    backgroundColor: colors.dojagoGreen2,
                                    content: Text(
                                      '$_bean은(는) 이미 설정한 원두 입니다.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                          _beans.add(_bean);
                          setState(() {});
                        }),
                  )
                ],
              ),
              Container(
                height: 46.0,
                child: Row(
                    children: [Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text('원두: '))]..addAll(List.generate(
                        _beans.length,
                        (i) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: GestureDetector(onTap: (){
                              setState(() {
                                _beans.remove(_beans[i]);
                              });
                            },child: Text('${_beans[i]}')))))),
              )
            ])),
      ])),
    );
  }

  Widget drink() {
    return Column(children: [hotInfo(), iceInfo()]);
  }

  Card iceInfo() {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Row(children: [
              Expanded(
                  child: Container(
                      height: 30,
                      child: Text('ICE',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))))
            ]),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Column(
                children: [
                  Row(
                    children: [Expanded(child: Text('가격'))],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            _menuTmp[value[0]][value[1]]['ice'] != null
                                ? _menuTmp[value[0]][value[1]]['ice']['가격']
                                    .length
                                : 0,
                            (index) => Padding(
                                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: Container(
                                      width: 75,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: colors.dojagoGreen2),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(_menuTmp[value[0]][value[1]]
                                                    ['ice']['가격']
                                                .keys
                                                .toList()[index]),
                                            Text(
                                                "${_menuTmp[value[0]][value[1]]['ice']['가격'].values.toList()[index]}"),
                                          ])),
                                ))
                          ..add((_menuTmp[value[0]][value[1]] == null ||
                                  _menuTmp[value[0]][value[1]]['ice'] == null ||
                                  _menuTmp[value[0]][value[1]]['ice']['가격']
                                          .length <
                                      3)
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(value[0]);
                                      print(value[1]);
                                      return _asyncAddSizePrice(
                                          context, value[0], value[1], 'ice');
                                    },
                                    child: Container(
                                      width: 75,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: colors.dojagoGreen2),
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                )
                              : Container()),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: colors.dojagoYello,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(children: [
                        Text('디카페인 가능'),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                            width: 100,
                            child: SizedBox(
                              width: 24,
                              height: 20,
                              child: Checkbox(
                                value: _iceDecaf,
                                onChanged: (v) {
                                  setState(() {
                                    _iceDecaf = !_iceDecaf;
                                  });
                                },
                              ),
                            ))
                      ]),
                    ),
                  ]),
                ],
              )),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Future _asyncAddSizePrice(
      BuildContext context, String category, String menu, String type) async {
    String _size = '';
    String _price = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Enter size with price'),
            content: new Column(
              children: [
                DropdownButton<String>(
                  focusColor: Colors.white,
                  value: _chosenSize,
                  elevation: 8,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: _cupSize.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        '$value-${_cupSize[value]}oz',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Please choose a cup size",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    _chosenSize = value;
                    setState(() => _chosenSize = value);
                    print(_chosenSize);
                  },
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Price', hintText: '3500'),
                    onChanged: (value) {
                      _price = value;
                    },
                  ),
                )
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
                    if ((_chosenSize == null) || (_price == '')) {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert',
                                  style: TextStyle(color: Colors.red)),
                              backgroundColor: colors.dojagoGreen2,
                              content: Text(
                                '빈칸을 모두 작성해주시기 바랍니다.',
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
                    if (_menuTmp[category][menu][type] == null) {
                      _menuTmp[category][menu][type] = {'가격': {}, '옵션': {}};
                    }
                    if (_menuTmp[category][menu][type]['가격']
                        .containsKey(_size)) {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert',
                                  style: TextStyle(color: Colors.red)),
                              backgroundColor: colors.dojagoGreen2,
                              content: Text(
                                '$_size은(는) 이미 설정하신 사이즈입니다.',
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
                      _menuTmp[category][menu][type]['가격'][_size] =
                          int.parse(_price);
                      Get.back();
                      setState(() {});
                    }
                  }),
            ],
          );
        });
      },
    );
  }

  Future _asyncEditSizePrice(BuildContext context, String category, String menu,
      String type, String size, int price) async {
    String _menuName = menu;
    String _size = size;
    String _price = "${price}";
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter size with price'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration:
                    new InputDecoration(labelText: 'Size', hintText: size),
                onChanged: (value) {
                  _size = value;
                },
              )),
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Price', hintText: '${price}'),
                onChanged: (value) {
                  _price = value;
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
                _menuTmp[category][menu][type]['가격'].remove(_size);
                Get.back();
                setState(() {});
              },
            ),
            FlatButton(
              child: Text('edit'),
              onPressed: () {
                // TODO: 사이즈랑 가격 수정
                // Map<dynamic, String> _tmp =
                // Map.fromIterables(_menu[category][menu][type]['가격'].values, _menu[category][menu][type]['가격'].keys);
                // var _tmpValue = _menu[category][menu];
                // _tmp[_tmpValue] = _menuName;
                // _menu[category] = Map.fromIterables(_tmp.values, _tmp.keys);
                // Get.back();
                // setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Card hotInfo() {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Row(children: [
              Expanded(
                  child: Container(
                      height: 30,
                      child: Text(
                        'HOT',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Column(
                children: [
                  Row(
                    children: [Expanded(child: Text('가격'))],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            _menuTmp[value[0]][value[1]]['hot'] != null
                                ? _menuTmp[value[0]][value[1]]['hot']['가격']
                                    .length
                                : 0,
                            (index) => Padding(
                                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: Container(
                                      width: 75,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: colors.dojagoGreen2),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(_menuTmp[value[0]][value[1]]
                                                    ['hot']['가격']
                                                .keys
                                                .toList()[index]),
                                            Text(
                                                "${_menuTmp[value[0]][value[1]]['hot']['가격'].values.toList()[index]}"),
                                          ])),
                                ))
                          ..add((_menuTmp[value[0]][value[1]] == null ||
                                  _menuTmp[value[0]][value[1]]['hot'] == null ||
                                  _menuTmp[value[0]][value[1]]['hot']['가격']
                                          .length <
                                      3)
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(value[0]);
                                      print(value[1]);
                                      return _asyncAddSizePrice(
                                          context, value[0], value[1], 'hot');
                                    },
                                    child: Container(
                                      width: 75,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: colors.dojagoGreen2),
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                )
                              : Container()),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: colors.dojagoYello,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(children: [
                        Text('디카페인 가능'),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                            width: 100,
                            child: SizedBox(
                              width: 24,
                              height: 20,
                              child: Checkbox(
                                value: _hotDecaf,
                                onChanged: (v) {
                                  setState(() {
                                    _hotDecaf = !_hotDecaf;
                                    print(_menuTmp);
                                  });
                                },
                              ),
                            ))
                      ]),
                    ),
                  ]),
                ],
              )),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Widget desert() {
    return Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: Column(
            children: [
              Row(
                children: [Expanded(child: Text('가격'))],
              ),
              SizedBox(
                height: 4,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(),
                          labelText: 'price',
                          hintText: '4000'),
                      onChanged: (v) {},
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ));
  }

  Widget etc() {
    return Container(
      color: Colors.yellow,
      width: 100,
      height: 50,
      child: Center(child: Text('준비중입니다.')),
    );
  }
}
