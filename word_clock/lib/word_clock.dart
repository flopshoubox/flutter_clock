// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

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

final _titlePartLabels = ["AM", "PM"];

final _specialTimes = ["Midnight", "Noon"];

class WordClock extends StatefulWidget {
  const WordClock(this.model);

  final ClockModel model;

  @override
  _WordClockState createState() => _WordClockState();
}

class _WordClockState extends State<WordClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  String _hoursInLetters;
  String _timeSeparator;
  String _minutesPart;
  String _titlePart;
  bool _isMidnight;
  bool _isNoon;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _dateTime = DateTime.parse("1969-07-20 11:55:04Z");
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(WordClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
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

  String _renderTitlePart(DateTime dateTime) {
    if (dateTime.hour < 12) return _titlePartLabels[0];
    return _titlePartLabels[1];
  }

  void _updateTime() {
    setState(() {
      // _dateTime = DateTime.now();
      _dateTime = _dateTime.add(new Duration(minutes: 1));
      _isMidnight = _dateTime.hour == 0 && _dateTime.minute == 0;
      _isNoon = _dateTime.hour == 12 && _dateTime.minute == 0;
      _hoursInLetters = _renderHoursPart(_dateTime);
      _timeSeparator = _renderTimeSeparator(_dateTime);
      _minutesPart = _renderMinutesPart(_dateTime);
      _titlePart = _renderTitlePart(_dateTime);
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      _timer = Timer(
        Duration(seconds: 1),
        _updateTime,
      );
    });
    developer.log('_hoursInLetters : $_hoursInLetters', name: 'clock app');
    developer.log('_timeSeparator : $_timeSeparator', name: 'clock app');
    developer.log('_minutesPart : $_minutesPart', name: 'clock app');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final titleTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: 150,
    );

    final boldSubtitleStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: 26,
      fontWeight: FontWeight.bold,
    );

    final defaultSubtitleStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: 26,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (!_isMidnight && !_isNoon)
          Container(
            height: 150,
            child: Text(
              _titlePart,
              style: titleTextStyle,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "It's",
              style: boldSubtitleStyle,
            ),
            SizedBox(
              width: 6,
            ),
            (_dateTime.minute != 0)
                ? Text(
                    _minutesPart,
                    style: boldSubtitleStyle,
                  )
                : Text(
                    _hoursInLetters,
                    style: boldSubtitleStyle,
                  ),
            if (_dateTime.minute != 0)
              SizedBox(
                width: 6,
              ),
            if (_dateTime.minute != 0)
              Text(
                _timeSeparator,
                style: defaultSubtitleStyle,
              ),
            SizedBox(
              width: 6,
            ),
            if (_dateTime.minute != 0)
              Text(
                '$_hoursInLetters.',
                style: boldSubtitleStyle,
              ),
            if (_dateTime.minute == 0 && !_isMidnight && !_isNoon)
              Text(
                '$_minutesPart.',
                style: boldSubtitleStyle,
              ),
          ],
        ),
      ],
    );
  }
}
