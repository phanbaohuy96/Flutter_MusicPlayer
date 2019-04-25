import 'dart:math';

import 'package:flutter/material.dart';

class RadioSeekBar extends StatefulWidget {

  final double trackWidth, progressWitdh, thumbSize, progressPer, thumbPos;
  final Color trackColor, progressColor, thumbColor;
  final Widget child;

  const RadioSeekBar({Key key, 
    this.trackWidth = 3.0, 
    this.progressWitdh = 5.0, 
    this.thumbSize = 10.0, 
    this.trackColor = Colors.grey, 
    this.progressColor = Colors.black, 
    this.thumbColor = Colors.black, 
    this.progressPer = 0.0, 
    this.thumbPos = 0.0,
    this.child
  }) : super(key: key);
   
  @override
  _RadioSeekBarState createState() => _RadioSeekBarState();
}

class _RadioSeekBarState extends State<RadioSeekBar> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadioSeekBarPainter(
        trackWidth: widget.trackWidth,
        trackColor: widget.trackColor,
        progressWitdh: widget.progressWitdh,
        progressColor: widget.progressColor,
        progressPer: widget.progressPer,
        thumbSize: widget.thumbSize,
        thumbColor: widget.thumbColor,
        thumbPos: widget.thumbPos
      ),
      child: widget.child,
    );
  }
}

class RadioSeekBarPainter extends CustomPainter{

  final double trackWidth, progressWitdh, thumbSize, progressPer, thumbPos;
  final Paint trackPaint, progressPaint, subProgressPaint, thumbPaint;

  RadioSeekBarPainter({
    @required this.trackWidth, 
    @required this.progressWitdh, 
    @required this.thumbSize, 
    @required this.progressPer, 
    @required this.thumbPos, 
    @required trackColor,
    @required progressColor,
    @required thumbColor
    }) : trackPaint = Paint() ..color = trackColor ..style = PaintingStyle.stroke ..strokeWidth = trackWidth,
         progressPaint = Paint() ..color = progressColor ..style = PaintingStyle.stroke ..strokeWidth = progressWitdh ..strokeCap = StrokeCap.round,
         subProgressPaint = Paint() ..color = progressColor.withOpacity(0.5) ..style = PaintingStyle.stroke ..strokeWidth = progressWitdh ..strokeCap = StrokeCap.round,
         thumbPaint = Paint() ..color = thumbColor ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 1.75;

    //paint fringer of widget
    canvas.drawCircle(center, min(size.width, size.height) / 2, trackPaint);

    //Paint track
    canvas.drawCircle(center, radius, trackPaint);

    //Paint sub progress
    final subProgressAngle =  2 * (pi ?? 3.14) * (thumbPos ?? 0.0);   
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius
      ),
      -pi / 2, 
      subProgressAngle, 
      false, 
      subProgressPaint);

    //Paint progress
    final progressAngle =  2 * (pi ?? 3.14) * (progressPer ?? 0.0);   
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius
      ),
      -pi / 2, 
      progressAngle, 
      false, 
      progressPaint);
    
    //paint thumb
    final thumbRadius = thumbSize / 2.0;    
    final thumbAngle = 2 * (pi ?? 3.14) * (thumbPos ?? 0.0) - (pi / 2);
    final thumbCenter = Offset(cos(thumbAngle) * radius, sin(thumbAngle) * radius) + center;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}