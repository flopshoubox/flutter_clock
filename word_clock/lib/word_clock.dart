// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

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

class WordClock extends StatefulWidget {
  const WordClock(this.model);

  final ClockModel model;

  @override
  _WordClockState createState() => _WordClockState();
}

class _WordClockState extends State<WordClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
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
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
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

    return Container(
      color: colors[_Element.background],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
            child: Text(
              'AM',
              style: titleTextStyle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'twenty two',
                style: boldSubtitleStyle,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'past',
                style: defaultSubtitleStyle,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'four.',
                style: boldSubtitleStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
