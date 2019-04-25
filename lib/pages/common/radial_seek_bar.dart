import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/pages/common/radio_seek_bar.dart';
import 'package:music_player/styles/colors_style.dart';

class RadialSeekBar extends StatefulWidget {

  final double progress;
  final double seekPer;
  final Function(double) onSeekRequested;

  const RadialSeekBar({Key key, this.seekPer = 0.0, this.progress, this.onSeekRequested}) : super(key: key);

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {

  double _progress = 0.1;
  PolarCoord _startDragCoord;
  double _startDragPer, _curDragPer;
  

  _onDragStart(PolarCoord startCoord) {
    _startDragCoord = startCoord;
    _startDragPer = _progress;
  }
  
  _onDragUpdate(PolarCoord updateCoord) {
    final dragAngle = updateCoord.angle -  _startDragCoord.angle;
    final dragPer = dragAngle / (2 * pi);
    setState(() {
     _curDragPer = ((_startDragPer ?? 0.0) + (dragPer ?? 0.0)) % 1.0; 
    });
  }

  _onDragEnd() {
    if(widget.onSeekRequested != null)
    {
      widget.onSeekRequested(_curDragPer);
    }

    setState(() {
      _curDragPer = null;
      _startDragPer = 0.0;
      _startDragCoord = null; 
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    this._progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    double thumbPos = _progress;
    if(_curDragPer != null)
      thumbPos = _curDragPer;
    else if (widget.seekPer != null)
      thumbPos = widget.seekPer;


    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          RadialDragGestureDetector(
            onRadialDragUpdate: _onDragUpdate,
            onRadialDragStart: _onDragStart,
            onRadialDragEnd: _onDragEnd,
            child: Center(
              child: SizedBox(
                width: 230.0,
                height: 230.0,
                child: Transform.rotate(
                  angle: thumbPos * 6.2,
                  child: ClipOval(
                    clipper: CircleClip(),
                    child: Image.asset(
                      "assets/images/disk.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 125.0,
              height: 125.0,
              child: RadioSeekBar(
                progressPer:  _progress,
                progressColor: progressColor,
                thumbColor: progressColor,
                thumbPos: thumbPos,
                trackColor: Colors.grey.withOpacity(0.5),
                trackWidth: 1,
                child: ClipOval(
                  clipper: CircleClip(),
                  child: Image.network(
                    demoPlaylist.songs[0].albumArtUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleClip extends CustomClipper<Rect>{

  @override
  getClip(Size size) {
    // TODO: implement getClip 
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2
    );
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}