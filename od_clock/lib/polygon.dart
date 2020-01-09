import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class PolygonShape extends StatelessWidget {
  PolygonShape(
      {this.height,
      this.width,
      this.fShadow,
      this.sShadow,
      this.containerColor,
      this.text,
      this.textStyle,
      this.rotation,});
  final double height;
  final double width;
  final Color fShadow;
  final Color sShadow;
  final Color containerColor;
  final text;
  final TextStyle textStyle;
  final double rotation;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ClipPolygon(
        sides: 6,
        borderRadius: 5.0, 
        rotate: rotation, 
        boxShadows: [
          PolygonBoxShadow(color: fShadow, elevation: 1.0),
          PolygonBoxShadow(color: sShadow, elevation: 2.0)
        ],
        child: Container(
          color: containerColor,
          child: Container(
            alignment: Alignment.center,
            child: Text(text, style: textStyle),
          ),
        ),
      ),
    );
  }
}

