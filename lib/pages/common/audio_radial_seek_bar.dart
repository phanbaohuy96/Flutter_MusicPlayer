import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/pages/common/radial_seek_bar.dart';

class AudioRadialSeekBar extends StatefulWidget {
  @override
  _AudioRadialSeekBarState createState() => _AudioRadialSeekBarState();
}

class _AudioRadialSeekBarState extends State<AudioRadialSeekBar> {

  double _seekPer;

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking
      ],
      playerBuilder: (context, player, child){
        double playBackProgress = 0.0;
        if (player.audioLength != null && player.position != null)
        {
          playBackProgress = player.position.inMilliseconds / player.audioLength.inMilliseconds;
        }

        _seekPer = player.isSeeking ? _seekPer : null;

        return RadialSeekBar(
          progress: playBackProgress,
          seekPer: _seekPer,
          onSeekRequested: (seek){
            setState(() {
              _seekPer = seek; 
            });

            final seekMillis = (player.audioLength.inMilliseconds * seek).round();
            player.seek(new Duration(milliseconds: seekMillis));
          },
        );
      },
    );
  }
}