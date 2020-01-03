import 'package:flutter/material.dart';

class ApPmLabel extends StatelessWidget {
  bool _isMidnight;
  bool _isNoon;
  String _label;

  ApPmLabel(DateTime dateTime, bool isMidnight, bool isNoon) {
    this._isMidnight = isMidnight;
    this._isNoon = isNoon;
    this._label = (dateTime.hour < 12) ? 'AM' : 'PM';
  }

  final titleTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Montserrat',
    fontSize: 210,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: (!_isMidnight && !_isNoon)
            ? Container(
                height: 210,
                child: Text(
                  _label,
                  style: titleTextStyle,
                ),
              )
            : SizedBox.shrink());
  }
}
