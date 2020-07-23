import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Classes {
  String _className, _location;
  Timestamp _startDate, _endDate;
  Timestamp _startTime;
  String _duration, _class_image;
  bool _daily;
  String _about, _host;
  bool _isFree;
  double fees;
  String _userId, _classId;
  Map<String, dynamic> _members;

  Map<String, dynamic> get members => _members;

  set members(Map<String, dynamic> value) {
    _members = value;
  }

  get host => _host;

  set host(value) {
    _host = value;
  }

  get class_image => _class_image;

  set class_image(value) {
    _class_image = value;
  }

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

  Timestamp get startTime => _startTime;

  set startTime(Timestamp value) {
    _startTime = value;
  }

  Timestamp get startDate => _startDate;

  set startDate(Timestamp value) {
    _startDate = value;
  }

  set location(value) {
    _location = value;
  }

  String get duration => _duration;

  set duration(String value) {
    _duration = value;
  }

  get endDate => _endDate;

  set endDate(value) {
    _endDate = value;
  }
}
