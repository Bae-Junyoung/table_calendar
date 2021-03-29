import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReservationController extends GetxController {
  bool _ordering = false;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List> _toDayEvents;
  Map<DateTime, List> _events;
  List _selectedEvents;

  bool get ordering => _ordering;

  DateTime get selectedDay => _selectedDay;

  Map<DateTime, List> get toDayEvents => _toDayEvents;

  Map<DateTime, List> get events => _events;

  List get selectedEvents => _selectedEvents;

  set setOrdering(bool ordering) {
    _ordering = ordering;
  }

  set setSelectedDay(DateTime selectedDay) {
    _selectedDay = selectedDay;
  }

  set setToDayEvents(Map<DateTime, List> toDayEvents) {
    _toDayEvents = toDayEvents;
  }

  set setEvents(Map<DateTime, List> events) {
    _events = events;
  }

  set setSelectedEvents(List selectedEvents) {
    _selectedEvents = selectedEvents;
  }

  selectedDayEventsList(List events) {
    _selectedEvents = events;
    update();
  }

  orderingToggle() {
    _ordering = !_ordering;
    update();
  }
}
