import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar_example/tap_drawer.dart';

import 'cafe_information_setting_page.dart';
import 'calendar_page.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  DateTime _currentDay = reservationController.selectedDay;
  List thisDayEvents = reservationController.selectedEvents;

  @override
  void initState() {
    super.initState();
  }

  String _getCurrentDate(DateTime date) {
    var formattedDate = "${date.year}년 ${date.month}월 ${date.day}일";

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getCurrentDate(_currentDay),
          textScaleFactor: 1.2,
          style: TextStyle(color: Color(0xFFFCF976)),
        ),
        backgroundColor: Color(0xFF3797A4),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/main_page'));
              })
        ],
      ),
      body: TimetableView(
        laneEventsList: _buildLaneEvents(thisDayEvents),
        timetableStyle: TimetableStyle(
          laneWidth: 100,
          timeItemTextColor: Colors.black,
          timelineColor: Colors.black,
        ),
      ),
      drawer: TapDrawer(),
    );
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  List<LaneEvents> _buildLaneEvents(List _events) {
    List lst = List.generate(
        cafeInformationController.numberOfTable, (index) => index + 1);

    Map<String, List<TableEvent>> event =
        Map.fromIterable(lst, key: (i) => i.toString(), value: (v) => []);

    for (int i = 0; i < _events.length; i++) {
      if (event[_events[i]['table_num'].toString()] == null) {
        event[_events[i]['table_num'].toString()] = [
          TableEvent(
              title: '${_events[i]["people_num"]}인',
              start: TableEventTime(
                  hour: int.parse(_events[i]['start_time'].substring(0, 2)),
                  minute: int.parse(_events[i]['start_time'].substring(3, 5))),
              end: TableEventTime(
                  hour: int.parse(_events[i]['end_time'].substring(0, 2)),
                  minute: int.parse(_events[i]['end_time'].substring(3, 5))),
              decoration: BoxDecoration(color: Colors.brown[300])),
        ];
      } else {
        event[_events[i]['table_num'].toString()]
          ..addAll([
            TableEvent(
                title: '${_events[i]["people_num"]}인',
                start: TableEventTime(
                    hour: int.parse(_events[i]['start_time'].substring(0, 2)),
                    minute:
                        int.parse(_events[i]['start_time'].substring(3, 5))),
                end: TableEventTime(
                    hour: int.parse(_events[i]['end_time'].substring(0, 2)),
                    minute: int.parse(_events[i]['end_time'].substring(3, 5))),
                decoration: BoxDecoration(color: Colors.brown[300])),
          ]);
      }
    }
    return List.generate(
        cafeInformationController.numberOfTable,
        (index) => LaneEvents(
              lane: Lane(
                  width: 100,
                  name: 'TABLE ${index + 1}',
                  textStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              events: event['${index + 1}'] == null ? [] : event['${index + 1}']
                ..addAll([
                  TableEvent(
                    title:'',
                      start: TableEventTime(
                          hour: 0,
                          minute: 0),
                      end: TableEventTime(
                          hour: int.parse(cafeInformationController.openTime
                              .substring(0, 2)),
                          minute: int.parse(cafeInformationController.openTime
                              .substring(3, 5))),
                      decoration: BoxDecoration(color: Colors.black)),
                  TableEvent(
                      title:'',
                      start: TableEventTime(
                          hour: int.parse(cafeInformationController.closeTime
                              .substring(0, 2)),
                          minute: int.parse(cafeInformationController.closeTime
                              .substring(3, 5))),
                      end: TableEventTime(
                          hour: 24,
                          minute: 0),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.black)),
                ]),
            ));
  }
}
