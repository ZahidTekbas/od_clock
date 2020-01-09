import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'polygon.dart';

enum _Element {
  background,
  text,
  shadow,
  containerColor,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
  _Element.containerColor : Colors.black
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
  _Element.containerColor: Colors.grey[700]
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  var temperature = '';
  var temperatureRange = '';
  var condition = '';
  var location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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
      temperature = widget.model.temperatureString;
      temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      condition = widget.model.weatherString;
      location = widget.model.location;
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

  double rotation = 90.0;
  double height = 125.0;
  double width = 125.0;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = 40.0;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Iceland',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(2, 0),
        ),
      ],
    );
    final subStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Iceland',
      fontSize: fontSize / 1.5,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(2, 0),
        ),
      ],
    );
    final rangeStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Iceland',
      fontSize: fontSize / 2.2,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(2, 0),
        ),
      ],
    );
    return Container(
      alignment: Alignment.center,
      color: colors[_Element.background],
      child: Center(
        child: Stack(
          alignment: FractionalOffset.center,
          children: <Widget>[
            Positioned(
                top: -10.0,
                left: 200.0,
                child: PolygonShape(
                  rotation: rotation,
                  height: height,
                  width: width,
                  fShadow: Colors.black54,
                  sShadow: Colors.grey[200],
                  containerColor: Colors.black54,
                  text: location,
                  textStyle: subStyle,
                )),
            Positioned(
              top: -10.0,
              left: 0.0,
              child: PolygonShape(
                rotation: rotation,
                height: height,
                width: width,
                fShadow: Colors.black54,
                sShadow: Colors.grey[200],
                containerColor: Colors.black54,
                text: temperature,
                textStyle: subStyle,
              ),
            ),
            Positioned(
              top: 50.0,
              left: 100.0,
              child: Container(
                height: height,
                width: width,
                child: ClipPolygon(
                  sides: 6,
                  borderRadius: 5.0, 
                  rotate: 90.0, 
                  boxShadows: [
                    PolygonBoxShadow(color: Colors.black, elevation: 1.0),
                    PolygonBoxShadow(color: Colors.black, elevation: 1.0)
                  ],
                  child: Container(
                    color: colors[_Element.containerColor],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          hour,
                          style: defaultStyle,
                        ),
                        Text(':', style: defaultStyle),
                        Text(
                          minute,
                          style: defaultStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100.0,
              left: 200.0,
              child: PolygonShape(
                rotation: rotation,
                height: height,
                width: width,
                fShadow: Colors.black54,
                sShadow: Colors.grey[200],
                containerColor: Colors.black54,
                text: condition,
                textStyle: subStyle,
              ),
            ),
            Positioned(
                top: 100.0,
                left: 0.0,
                child: PolygonShape(
                  rotation: rotation,
                  height: height,
                  width: width,
                  fShadow: Colors.black54,
                  sShadow: Colors.grey[200],
                  containerColor: Colors.black54,
                  text: temperatureRange,
                  textStyle: rangeStyle,
                )),
          ],
        ),
      ),
    );
  }
}
