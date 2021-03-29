import 'package:flutter/material.dart';
import 'package:table_calendar_example/page/cafe_information_setting_page.dart';

class TapDrawer extends StatefulWidget {
  @override
  _TapDrawerState createState() => _TapDrawerState();
}

class _TapDrawerState extends State<TapDrawer> {
  Color _color = Color.fromRGBO(115, 253, 255, 1);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage(
                                    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=http%3A%2F%2Fcfile9.uf.tistory.com%2Fimage%2F999A504E5E0EF3233039F5"))),
                      )),
                ),
                Container(
                    child: Text(
                      cafeInformationController.cafeNameController.text,
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                )),
            duration: Duration(seconds: 3),
          ),
          ListTile(
            title: Text('예약현황조회'),
            onTap: () {
              print('예약현황조회');
            },
          ),
          ListTile(
            title: Text('카페정보설정'),
            onTap: () {
              print('카페정보설정');
            },
          ),
          ListTile(
            title: Text('대시보드'),
            onTap: () {
              print('대시보드');
            },
          ),
          ListTile(
            title: Text('리뷰관리'),
            onTap: () {
              print('리뷰관리');
            },
          ),
          ListTile(
            title: Text('공지사항'),
            onTap: () {
              print('공지사항');
            },
          ),
          ListTile(
            title: Text('예약알림 설정'),
            onTap: () {
              print('예약알림 설정');
            },
          ),
          ListTile(
            title: Text('커뮤니티'),
            onTap: () {
              print('커뮤니티');
            },
          ),
          ListTile(
            title: Text('이벤트'),
            onTap: () {
              print('이벤트');
            },
          ),
          ListTile(
            title: Text('FAQ'),
            onTap: () {
              print('FAQ');
            },
          ),
          ListTile(
            title: Text('이용약관'),
            onTap: () {
              print('이용약관');
            },
          ),
          ListTile(
            title: Text('개인정보처리방침'),
            onTap: () {
              print('개인정보처리방침');
            },
          ),

        ],
      ),
    );
  }
}