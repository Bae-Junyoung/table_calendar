import 'package:flutter/material.dart';
import 'package:table_calendar_example/tap_drawer.dart';

import 'calendar_home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              })
        ],
      ),
      body: Column(children: <Widget>[
        Container(
          height: 100,
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              _buildCards(
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Colors.white,
                  ),
                  '예약현황조회',
                  CalendarHome(
                    title: 'doljago',
                  )),
              _buildCards(
                  Icon(Icons.settings, size: 80, color: Colors.white),
                  '카페정보설정',
                  CalendarHome(
                    title: 'doljago',
                  )),
              _buildCards(
                  Icon(Icons.dashboard, size: 80, color: Colors.white),
                  '대시보드',
                  CalendarHome(
                    title: 'doljago',
                  )),
              _buildCards(
                  Icon(Icons.rate_review, size: 80, color: Colors.white),
                  '리뷰관리',
                  CalendarHome(
                    title: 'doljago',
                  )),
            ],
          ),
        ),
      ]),
      drawer: TapDrawer(),
    );
  }

  Card _buildCards(Icon _icon, String _name, Widget w) {
    Card card = Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => w),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                child: _icon,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0))),
            Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                _name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
    return card;
  }
}
