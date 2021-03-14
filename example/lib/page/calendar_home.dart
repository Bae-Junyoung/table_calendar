import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar_example/tap_drawer.dart';
import 'package:table_calendar_example/timetable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' show utf8;

import 'Response.dart';

String responseString = '''
{
    "status": "ok",
    "message": "Event Is Found",
    "data": [
              {
                  "reserv_num": 11,
                  "created_at": "2021-03-03T16:17:30.406796+09:00",
                  "people_num": 2,
                  "table_num": 4,
                  "start_time": "2021-03-04T14:15:00+09:00",
                  "end_time": "2021-03-04T16:00:00+09:00",
                  "message": "가나다라마바사아"
              },
              {
                  "reserv_num": 13,
                  "created_at": "2021-03-03T16:18:09.296605+09:00",
                  "people_num": 2,
                  "table_num": 1,
                  "start_time": "2021-03-08T15:15:00+09:00",
                  "end_time": "2021-03-08T16:30:00+09:00",
                  "message": "자차카타파하"
              },
              {
                  "reserv_num": 17,
                  "created_at": "2021-03-04T16:11:00.296605+09:00",
                  "people_num": 3,
                  "table_num": 4,
                  "start_time": "2021-03-08T17:00:00+09:00",
                  "end_time": "2021-03-08T18:30:00+09:00",
                  "message": "가가가가가가"
              },
              {
                  "reserv_num": 19,
                  "created_at": "2021-03-04T16:11:00.296605+09:00",
                  "people_num": 2,
                  "table_num": 2,
                  "start_time": "2021-03-11T17:00:00+09:00",
                  "end_time": "2021-03-11T18:30:00+09:00",
                  "message": "나나나나나나"
              }
            ]
}
    ''';

final Map<DateTime, List> holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class CalendarHome extends StatefulWidget {
  CalendarHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome>
    with TickerProviderStateMixin {
  bool _selected = false;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List> _toDayEvents;
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  TextEditingController _eventController;
  CalendarController _controller;

  Future<List<Datum>> getAllEvent() async {
    try {
      final response = await http.get(
        'http://10.0.2.2:8000/reservation/cafe/',
      );
      responseString = '''{"status": "ok",
    "message": "Event Is Found",
    "data": ''' +
          utf8.decode(response.bodyBytes) +
          '}';
      // print(responseString);

      final Map<String, dynamic> responseJson = json.decode(responseString);
      if (responseJson["status"] == "ok") {
        List eventList = responseJson['data'];
        final result =
            eventList.map<Datum>((json) => Datum.fromJson(json)).toList();
        print(result[0]);
        return result;
      } else {
        //throw CustomError(responseJson['message']);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Map<DateTime, List>> getTask1() async {
    Map<DateTime, List> mapFetch = {};
    List<Datum> event = await getAllEvent();
    for (int i = 0; i < event.length; i++) {
      var createTime = DateTime(event[i].start_time.year,
          event[i].start_time.month, event[i].start_time.day);
      var original = mapFetch[createTime];
      if (original == null) {
        // print("null");
        mapFetch[createTime] = [
          {
            'people_num': event[i].people_num,
            'table_num': event[i].table_num,
            'start_time':
                '${event[i].start_time.hour.toString().padLeft(2, '0')}:${event[i].start_time.minute.toString().padLeft(2, '0')}:${event[i].start_time.second.toString().padLeft(2, '0')}',
            'end_time':
                '${event[i].end_time.hour.toString().padLeft(2, '0')}:${event[i].end_time.minute.toString().padLeft(2, '0')}:${event[i].end_time.second.toString().padLeft(2, '0')}',
            'message': event[i].message,
          }
        ];
      } else {
        // print(event[i].message);
        mapFetch[createTime] = List.from(original)
          ..addAll([
            {
              'people_num': event[i].people_num,
              'table_num': event[i].table_num,
              'start_time':
                  '${event[i].start_time.hour.toString().padLeft(2, '0')}:${event[i].start_time.minute.toString().padLeft(2, '0')}:${event[i].start_time.second.toString().padLeft(2, '0')}',
              'end_time':
                  '${event[i].end_time.hour.toString().padLeft(2, '0')}:${event[i].end_time.minute.toString().padLeft(2, '0')}:${event[i].end_time.second.toString().padLeft(2, '0')}',
              'message': event[i].message,
            }
          ]);
      }
    }

    return mapFetch;
  }

  @override
  void initState() {
    // super.initState();
    final _toDay = DateTime.now();

    _selectedEvents = [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTask1().then((val) => setState(() {
            _events = val;
          }));
      //print( ' ${_events.toString()} ');
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    print(day);
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/main_page'));
              })
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendarWithBuilders(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(_selectedDay),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
      drawer: TapDrawer(),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'ko-KR',
      calendarController: _calendarController,
      events: _events,
      holidays: holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.twoWeeks: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.red[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.red[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrange[300],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 18.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.amber[400],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
        _selectedDay = date;
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons(DateTime setDay) {
    final dateTime = setDay;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 8,
        ),
        RaisedButton(
          color: Colors.blue[400],
          elevation: 8,
          textColor: Colors.white,
          child:
              Text('go to ${dateTime.year}-${dateTime.month}-${dateTime.day}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
            // print(_calendarController.focusedDay.runtimeType);
            // print(_selectedEvents[0]['start_time'].runtimeType);
            print(_selectedEvents);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TimeTable(date: _calendarController.focusedDay, events: _selectedEvents)),
            );
          },
        ),
        SizedBox(
          width: 8,
        ),
        RaisedButton(
          color: Colors.blue[400],
          elevation: 8,
          textColor: Colors.white,
          child: _selected
              ? Text(
                  '시간순',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : Text('예약순', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            setState(() {
              _selected = !_selected;
            });
          },
        ),
      ],
    );
  }

  _showAddDialog(String text) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white70,
              title: Text(text),
            ));
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(
                      '${event['table_num']}번 테이블 : ${event['people_num']}명'),
                  subtitle:
                      Text('${event['start_time']} - ${event['end_time']}'),
                  onTap: () {
                    _showAddDialog(event["message"]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.near_me),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      print('가는 중입니다.');
                    },
                  ),
                ),
              ))
          .toList(),
    );
  }
}
