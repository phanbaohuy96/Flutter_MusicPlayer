import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/styles/colors_style.dart';
import 'package:music_player/styles/text_styles.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(            
      width: double.infinity,
      child: Material(
        color: accentColor,              
        child: Padding(
          padding: EdgeInsets.only(bottom: 50, top: 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${demoPlaylist.songs[0].songTitle}\n",
                        style: songTitleStyle
                      ),
                      TextSpan(                        
                        text: "${demoPlaylist.songs[0].artist}\n",
                        style: actistNameStyle
                      ),
                    ]
                  ),
                ),
              ),
              Row(                  
                children: <Widget>[
                  Expanded(child: SizedBox(),),

                  IconButton(
                    splashColor: lightAccentColor,
                    highlightColor: lightAccentColor.withOpacity(0.5),
                    icon: Icon(Icons.skip_previous, color: Colors.white, size: 40,),
                    onPressed: (){},
                  ),

                  Expanded(child: SizedBox(),),

                  new PlayPauseButton(),

                  Expanded(child: SizedBox(),),

                  IconButton(
                    splashColor: lightAccentColor,
                    highlightColor: lightAccentColor.withOpacity(0.5),
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 40,),
                    onPressed: (){},
                  ),

                  Expanded(child: SizedBox(),),
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [WatchableAudioProperties.audioPlayerState],
      playerBuilder: (context, player, child){
        IconData icon = Icons.music_note;
        Color buttonColor = lightAccentColor;
        Function onPressed;
        if(player.state == AudioPlayerState.playing)
        {
          icon  = Icons.pause;
          onPressed = player.pause;
          buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.completed || player.state == AudioPlayerState.paused)
        {
          icon = Icons.play_arrow;
          onPressed = player.play;
        }

        return RawMaterialButton(                      
          shape: CircleBorder(),
          fillColor: buttonColor,
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor.withOpacity(0.5),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: darkAccentColor,
              size: 35.0
            ),
          ),
        );
      },
    );
  }
}