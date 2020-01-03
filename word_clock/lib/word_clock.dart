// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/am_pm_label.dart';
import 'package:digital_clock/time_label.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import './am_pm_label.dart';

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

class WordClock extends StatefulWidget {
  const WordClock(this.model);

  final ClockModel model;

  @override
  _WordClockState createState() => _WordClockState();
}

class _WordClockState extends State<WordClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  bool _isMidnight;
  bool _isNoon;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _dateTime = DateTime.parse("1969-07-20 11:45:04Z");
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

  void _updateTime() {
    setState(() {
      // _dateTime = DateTime.now();
      _dateTime = _dateTime.add(new Duration(minutes: 1));
      _isMidnight = _dateTime.hour == 0 && _dateTime.minute == 0;
      _isNoon = _dateTime.hour == 12 && _dateTime.minute == 0;

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
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ApPmLabel(_dateTime, _isMidnight, _isNoon),
        SizedBox(
          height: 10,
        ),
        TimeLabel(_dateTime, _isMidnight, _isNoon),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
