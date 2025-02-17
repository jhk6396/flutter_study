import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPPlayer extends StatefulWidget {
  const AudioPPlayer({super.key});

  @override
  State<AudioPPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPPlayer> {
  final player = AudioPlayer();
  //이미지
  String imgUrl = '';
  //url
  String url = 'https://download.samplelib.com/mp3/sample-15s.mp3';
  //음원 길이 position
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  bool isPlaying = false;
  double volume = 0.5;
  bool isVolumeDisabled = false;

  // 분:초 시간
  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void handlePlayPause() {
    if (player.playing){
      player.pause();
    }else {
      player.play();
    }
  }

  // 음소거
  void _disableVolume() async {
    //set Volume to 0
    await player.setVolume(0);
    setState(() {
      if (volume > 0) {
        isVolumeDisabled = true;
      }
    });
  }

  // 음소거 해제
  void _activateVolume() async {
    // set volumn to previous value before it was 0
    await player.setVolume(volume);
    setState(() {
      isVolumeDisabled = false;
    });
  }

  // 볼륨 아이콘 세팅
  IconData _getVolumeIcon() {
    return (player.volume == 0) ? Icons.volume_off : Icons.volume_up_rounded;
  }

  void _playAudio() async {
    setState(() {
      isPlaying = true;
    });

    await player.play();
  }

  void _pauseAudio() async {
    setState(() {
      isPlaying = false;
    });

    await player.pause();
  }

  // 재생 아이콘 세팅
  IconData _getPlayPauseIcon() {
    return (isPlaying) ? Icons.pause : Icons.play_arrow;
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    _initialize();
  }
  //init
  void _initialize() async {
    await player.setUrl(url);

    player.positionStream.listen((p) {
      setState(() => position = p);
    });

    player.durationStream.listen((d) {
      setState(() => duration = d!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Title 제목쓰..'),
          SizedBox(
            height: 200,
            width: 300,
            child: Image.network(imgUrl),
          ),
          Text(formatDuration(position)),
          Slider(
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: handleSeek,
          ),
          Text(formatDuration(duration)),
        ],
      ),

    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
