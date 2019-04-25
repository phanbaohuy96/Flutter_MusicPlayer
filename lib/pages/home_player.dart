import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/pages/common/audio_radial_seek_bar.dart';
import 'package:music_player/pages/common/bottom_controls.dart';
import 'package:fluttery_audio/fluttery_audio.dart';


class HomePlayer extends StatefulWidget {
  @override
  _HomePlayerState createState() => _HomePlayerState();
}

class _HomePlayerState extends State<HomePlayer> {

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

    return AudioPlaylist(
      playlist: demoPlaylist.songs.map((song){
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //Seek bar
            Expanded(
              child: AudioRadialSeekBar()
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



