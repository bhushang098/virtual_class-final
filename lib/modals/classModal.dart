import 'package:flutter/material.dart';

class Classes {
  String _className, _location;
  DateTime _startDate, _endDate;
  TimeOfDay _startTime;
  String _duration;
  bool _daily;
  String _about;
  bool _isFree;
  double fees;
  String _userId, _classId;

  String get className => _className;

  set className(String value) {
    _className = value;
  }

  get location => _location;

  get classId => _classId;

  set classId(value) {
    _classId = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  bool get isFree => _isFree;

  set isFree(bool value) {
    _isFree = value;
  }

  String get about => _about;

  set about(String value) {
    _about = value;
  }

  bool get daily => _daily;

  set daily(bool value) {
    _daily = value;
  }

  TimeOfDay get startTime => _startTime;

  set startTime(TimeOfDay value) {
    _startTime = value;
  }

  get endDate => _endDate;

  set endDate(value) {
    _endDate = value;
  }

  DateTime get startDate => _startDate;

  set startDate(DateTime value) {
    _startDate = value;
  }

  set location(value) {
    _location = value;
  }

  String get duration => _duration;

  set duration(String value) {
    _duration = value;
  }
}
