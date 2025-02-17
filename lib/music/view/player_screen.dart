import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  //이미지
  String imgUrl = '';
  //url
  String url = '';

  //오디오플레이어 변수
  late AudioPlayer player;
  bool isPlaying = false;
  double volume = 0.5;
  bool isVolumeDisabled = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  //init
  void _initialize() async {
    //생성자
    player = AudioPlayer();
    await player.setUrl(url);
    await player.setVolume(volume);
    setState(() {});
  }

  //dispose
  @override
  void dispose() {
    player.dispose();
    super.dispose();
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


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
