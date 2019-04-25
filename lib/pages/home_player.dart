import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/pages/common/audio_radial_seek_bar.dart';
import 'package:music_player/pages/common/bottom_controls.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/styles/colors_style.dart';


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
              child: AudioPlaylistComponent(
                playlistBuilder: (context, player, child){
                String albumArtUrl = demoPlaylist.songs[player.activeIndex].albumArtUrl;

                  return AudioRadialSeekBar(
                    albumArtUrl: albumArtUrl
                  );
                }
              )
            ),
          
            // Visualizer
            Container(
              width: double.infinity,
              height: 125.0,
              child: Visualizer(
                builder: (context, List<int> fft){
                  return CustomPaint(
                    child: Container(),
                    painter: VisualizerPainter(
                      fft: fft,
                      height: 125.0,
                      color: accentColor
                    ),
                  );
                },
              ),
            ),

            // Song title, artist name and controls
            AudioPlaylistComponent(
              playlistBuilder: (context, player, child){
                String songTitle = demoPlaylist.songs[player.activeIndex].songTitle;
                String artist = demoPlaylist.songs[player.activeIndex].songTitle;

                return Container(
                  child: BottomControls(
                    songTitle: songTitle,
                    artist: artist,
                  )
                );
              }
            )
            
          ],
        ),
      ),
    );
  }
}

class VisualizerPainter extends CustomPainter{
  final List<int> fft;
  final double height;
  final Color color;
  final Paint wavePaint;

  VisualizerPainter(
    {this.fft, this.height, this.color}
    ):wavePaint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.fill ;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    _renderWaves(canvas, size);
  }

  void _renderWaves(Canvas canvas, Size size)
  {
    final histogramLow = _createHistogram(fft, 15, 2, ((fft.length) / 4).floor());
    final histogramHigh = _createHistogram(fft, 15, (fft.length / 4).ceil(), (fft.length / 2).floor());

    _renderHistogram(canvas, size, histogramLow);
    _renderHistogram(canvas, size, histogramHigh);
  }  

  void _renderHistogram(Canvas canvas, Size size, List<int> histogram) {
    if(histogram.length == 0) return;

    final pointsToGraph = histogram.length;
    final widthPerSample = (size.width / (pointsToGraph -2)).floor();

    final points = List<double>.filled(pointsToGraph * 4, 0.0);

    for( int i = 0; i < pointsToGraph - 1; i++)
    {
      points[i * 4] = (i * widthPerSample).toDouble();
      points[i * 4 + 1] = size.height - histogram[i].toDouble();

      points[i * 4 + 2] = ((i + 1) * widthPerSample).toDouble();
      points[i * 4 + 3] = size.height - (histogram[i + 1].toDouble());
    }

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(points[0], points[1]);
    for(int i = 2; i  < points.length - 4; i += 2)
    {
      path.cubicTo(
        points[i - 2] + 10.0, points[i - 1], 
        points[i]  - 10.0, points[i + 1], 
        points[i], points[i + 1]
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  _createHistogram(List<int> samples, int bucketCount, [int start, int end]){
    if(start == end) return const [];

    start = start ?? 0;
    end = end ?? samples.length - 1;
    final sampleCount = end - start + 1;

    final samplesPerBucket = (sampleCount / bucketCount).floor();
    if(samplesPerBucket == 0) return const [];

    final actualSampleCount = sampleCount - (sampleCount % samplesPerBucket);
    List<int> histogram = new List<int>.filled(bucketCount, 0);

    //add up the frequency amounts for each bucket.
    for (int i = start; i <= start + actualSampleCount; ++i)
    {
      //ignore the imaginary half of  each FFT sample
      if((i - start) % 2 == 1) continue;

      int bucketIndex = ((i - start) / samplesPerBucket).floor();
      histogram[bucketIndex] += samples[i];
    }

    for (var i = 0; i < histogram.length; i++)
    {
      histogram[i] = (histogram[i] / samplesPerBucket).abs().round();
    }

    return histogram;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}



