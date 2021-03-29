import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar_example/controller/reservation_controller.dart';
import 'package:table_calendar_example/tap_drawer.dart';
import 'file:///C:/work/agit/table_calendar/example/lib/page/timetable_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:get/get.dart';
import '../model/reservation_information.dart';

// [{reserv_num: 13, created_at: 2021-03-03T16:18:09.296605+09:00, people_num: 2,
// table_num: 1, start_time: 2021-03-08T15:15:00+09:00, end_time: 2021-03-08T16:30:00+09:00,
// message: 자차카타파하},
// {reserv_num: 17, created_at: 2021-03-04T17:13:49.988574+09:00, people_num: 3,
// table_num: 4, start_time: 2021-03-08T17:00:00+09:00, end_time: 2021-03-08T18:30:00+09:00,
// message: 가가가가가가가가가가가},
// {reserv_num: 19, created_at: 2021-03-04T17:14:47.582332+09:00, people_num: 2,
// table_num: 2, start_time: 2021-03-11T17:00:00+09:00, end_time: 2021-03-11T18:30:00+09:00,
// message: 나나나나나나나나나나}, {reserv_num: 23, created_at: 2021-03-05T15:12:37.273852+09:00,
// people_num: 4, table_num: 1, start_time: 2021-03-17T14:15:00+09:00,
// end_time: 2021-03-17T16:00:00+09:00, message: qwesdfxcghjhnbgfd},
// {reserv_num: 29, created_at: 2021-03-15T19:49:51.600281+09:00, people_num: 1,
// table_num: 1, start_time: 2021-03-08T19:00:00+09:00, end_time: 2021-03-08T19:30:00+09:00,
// message: abcd}]

final Map<DateTime, List> holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};
ReservationController reservationController = Get.put(ReservationController());

class CalendarHome extends StatefulWidget {
  CalendarHome({Key key}) : super(key: key);

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome>
    with TickerProviderStateMixin {
  Map<DateTime, List> _toDayEvents;
  Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;

  TextEditingController _eventController;
  CalendarController _controller;

  Future<List<Datum>> getAllEvent() async {
    try {
      final response = await http.get(
        'http://10.0.2.2:8000/reservation/cafe/',
      );
      String responseString = '''{"status": "ok",
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
      var createTime = DateTime(event[i].startTime.year,
          event[i].startTime.month, event[i].startTime.day);
      var original = mapFetch[createTime];
      if (original == null) {
        // print("null");
        mapFetch[createTime] = [
          {
            'people_num': event[i].peopleNum,
            'table_num': event[i].tableNum,
            'start_time':
                '${event[i].startTime.hour.toString().padLeft(2, '0')}:${event[i].startTime.minute.toString().padLeft(2, '0')}:${event[i].startTime.second.toString().padLeft(2, '0')}',
            'end_time':
                '${event[i].endTime.hour.toString().padLeft(2, '0')}:${event[i].endTime.minute.toString().padLeft(2, '0')}:${event[i].endTime.second.toString().padLeft(2, '0')}',
            'message': event[i].message,
          }
        ];
      } else {
        // print(event[i].message);
        mapFetch[createTime] = List.from(original)
          ..addAll([
            {
              'people_num': event[i].peopleNum,
              'table_num': event[i].tableNum,
              'start_time':
                  '${event[i].startTime.hour.toString().padLeft(2, '0')}:${event[i].startTime.minute.toString().padLeft(2, '0')}:${event[i].startTime.second.toString().padLeft(2, '0')}',
              'end_time':
                  '${event[i].endTime.hour.toString().padLeft(2, '0')}:${event[i].endTime.minute.toString().padLeft(2, '0')}:${event[i].endTime.second.toString().padLeft(2, '0')}',
              'message': event[i].message,
            }
          ]);
      }
    }

    return mapFetch;
  }

  @override
  void initState() {
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTask1().then((val) => setState(() {
            reservationController.setEvents = val;
          }));
    });
    reservationController.setSelectedEvents = [];
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
    setState(() {
      reservationController.setSelectedEvents = events;
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
        title: Text('doljago'),
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
          GetBuilder<ReservationController>(
              init: reservationController,
              builder: (_) => _buildButtons(_.selectedDay)),
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
      events: reservationController.events,
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
        reservationController.setSelectedDay = date;
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimeTable()),
            );
          },
        ),
        SizedBox(
          width: 8,
        ),
        GetBuilder<ReservationController>(
            init: reservationController,
            builder: (_) {
              return RaisedButton(
                color: Colors.blue[400],
                elevation: 8,
                textColor: Colors.white,
                child: _.ordering
                    ? Text(
                        '시간순',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Text('예약순',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _.orderingToggle();
                  });
                },
              );
            })
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
      children: reservationController.selectedEvents
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
