import 'dart:developer' as developer;

import 'package:flutter/material.dart';

final _hours = [
  "twelve",
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
  "ten",
  "eleven"
];

final _minutes = [
  "o'clock",
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
  "ten",
  "eleven",
  "twelve",
  "thirteen",
  "fourteen",
  "quarter",
  "sixteen",
  "seventeen",
  "eighteen",
  "nineteen",
  "twenty",
  "twenty one",
  "twenty two",
  "twenty three",
  "twenty four",
  "twenty five",
  "twenty six",
  "twenty seven",
  "twenty eight",
  "twenty nine",
  "half"
];

final _specialTimes = ["Midnight", "Noon"];

class TimeLabel extends StatelessWidget {
  DateTime _dateTime;
  bool _isMidnight;
  bool _isNoon;
  String _hoursInLetters;
  String _timeSeparator;
  String _minutesPart;

  TimeLabel(DateTime dateTime, bool isMidnight, bool isNoon) {
    this._dateTime = dateTime;
    this._isMidnight = isMidnight;
    this._isNoon = isNoon;
    _hoursInLetters = _renderHoursPart(dateTime);
    _timeSeparator = _renderTimeSeparator(dateTime);
    _minutesPart = _renderMinutesPart(dateTime);
    developer.log('_hoursInLetters : $_hoursInLetters', name: 'clock app');
    developer.log('_timeSeparator : $_timeSeparator', name: 'clock app');
    developer.log('_minutesPart : $_minutesPart', name: 'clock app');
  }

  String _renderHoursPart(DateTime dateTime) {
    int twelveHourFormattedHour = dateTime.hour % 12;
    if (_isMidnight) return _specialTimes[0];
    if (_isNoon) return _specialTimes[1];

    return dateTime.minute < 30
        ? _hours[twelveHourFormattedHour]
        : _hours[(twelveHourFormattedHour + 1) % 12];
  }

  String _renderTimeSeparator(DateTime dateTime) {
    return dateTime.minute > 30 ? 'to' : 'past';
  }

  String _renderMinutesPart(DateTime dateTime) {
    var minutes = dateTime.minute > 30 ? 60 - dateTime.minute : dateTime.minute;
    return _minutes[minutes];
  }

  final boldSubtitleStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Montserrat',
    fontSize: 45,
    fontWeight: FontWeight.bold,
  );

  final defaultSubtitleStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Montserrat',
    fontSize: 45,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Positioned(
          left: 50,
          child: Text(
            (_dateTime.minute != 0) ? _minutesPart : _hoursInLetters,
            style: boldSubtitleStyle,
          ),
        ),
        if (_dateTime.minute != 0)
          Positioned(
            left: 250,
            child: Text(
              _timeSeparator,
              style: defaultSubtitleStyle,
            ),
          ),
        if (_dateTime.minute != 0)
          Positioned(
            left: 440,
            child: Text(
              _hoursInLetters,
              style: boldSubtitleStyle,
            ),
          ),
        if (_dateTime.minute == 0 && !_isMidnight && !_isNoon)
          Positioned(
            left: 350,
            child: Text(
              _minutesPart,
              style: boldSubtitleStyle,
            ),
          ),
        Text(
          '.',
          style: boldSubtitleStyle,
        ),
      ],
    );
  }
}
