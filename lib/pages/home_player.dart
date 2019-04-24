import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/pages/common/bottom_controls.dart';
import 'package:music_player/pages/common/radial_seek_bar.dart';
import 'package:fluttery_audio/fluttery_audio.dart';


class HomePlayer extends StatefulWidget {
  @override
  _HomePlayerState createState() => _HomePlayerState();
}

class _HomePlayerState extends State<HomePlayer> {

  double _seekPer;

  _buildAppBar()
  {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.grey,),
        onPressed: (){},
      ),

      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.menu, color: Colors.grey,),
          onPressed: (){},
          
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    

    return Audio(
      audioUrl: demoPlaylist.songs[0].audioUrl,
      playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //Seek bar
            Expanded(
              child: AudioComponent(
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
              )
            ),
          
            // Visualizer
            Container(
              width: double.infinity,
              height: 125.0,
            ),

            // Song title, artist name and controls
            new BottomControls()
          ],
        ),
      ),
    );
  }
}



