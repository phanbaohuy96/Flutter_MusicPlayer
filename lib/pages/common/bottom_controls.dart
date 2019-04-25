import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/styles/colors_style.dart';
import 'package:music_player/styles/text_styles.dart';

class BottomControls extends StatelessWidget {

  final String songTitle, artist;

  const BottomControls({
    Key key, this.songTitle, this.artist,
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
                        text: "$songTitle\n",
                        style: songTitleStyle
                      ),
                      TextSpan(                        
                        text: "$artist\n",
                        style: actistNameStyle
                      ),
                    ]
                  ),
                ),
              ),
              Row(
                    
                children: <Widget>[
                  Expanded(child: SizedBox(),),

                  new PreviousButton(),

                  Expanded(child: SizedBox(),),

                  new PlayPauseButton(),

                  Expanded(child: SizedBox(),),

                  new NextButton(),

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

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (context, playList, child){
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor.withOpacity(0.5),
          icon: Icon(Icons.skip_previous, color: Colors.white, size: 40,),
          onPressed: playList.previous,
        );
      },      
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (context, playList, child){
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor.withOpacity(0.5),
          icon: Icon(Icons.skip_next, color: Colors.white, size: 40,),
          onPressed: playList.next,
        );
      }
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