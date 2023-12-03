import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:record_with_play/providers/play_audio_provider.dart';
import 'package:record_with_play/providers/record_audio_provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class RecordAndPlayScreen extends ConsumerStatefulWidget {
  const RecordAndPlayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _RecordAndPlayScreenState();
}

class _RecordAndPlayScreenState extends ConsumerState {
  customizeStatusAndNavigationBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }

  @override
  void initState() {
    customizeStatusAndNavigationBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _recordProvider = ref.watch(RecordAudio);
    final _playProvider = ref.watch(PlayAudio);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://i.pinimg.com/originals/32/36/32/323632669c4dd277c50e4ad84296e7ae.jpg"))),
        child: Container(
          color: _recordProvider.recordedFilePath.isEmpty
              ? _recordProvider.backgroungcolor
              : (_recordProvider.recordedFilePath.isNotEmpty &&
                      !_playProvider.isSongPlaying)
                  ? _recordProvider.backgroungcolor
                  : Colors.black.withOpacity(.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              _recordProvider.recordedFilePath.isEmpty
                  ? _recordHeading()
                  : _playAudioHeading(),
              const SizedBox(height: 40),
              _recordProvider.recordedFilePath.isEmpty
                  ? _recordingSection()
                  : _audioPlayingSection(),
              if (_recordProvider.recordedFilePath.isNotEmpty &&
                  !_playProvider.isSongPlaying)
                const SizedBox(height: 40),
              if (_recordProvider.recordedFilePath.isNotEmpty &&
                  !_playProvider.isSongPlaying)
                _resetButton(),
            ],
          ),
        ),
      ),
    );
  }

  _recordHeading() {
    return const Center(
      child: Text(
        'Record Audio',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  _playAudioHeading() {
    return const Center(
      child: Text(
        'Play Audio',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  _recordingSection() {
    final _recordProvider = ref.read(RecordAudio);

    if (_recordProvider.isRecording) {
      return InkWell(
        onTap: () async {
          await _recordProvider.stopRecording();
        },
        child: RippleAnimation(
          repeat: true,
          color: const Color(0xff4BB543),
          minRadius: 45,
          ripplesCount: 8,
          child: _commonIconSection(),
        ),
      );
    }

    return InkWell(
      onTap: () async {
        await _recordProvider.recordVoice();
      },
      child: _commonIconSection(),
    );
  }

  _commonIconSection() {
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(Icons.keyboard_voice_rounded,
          color: Colors.white, size: 40),
    );
  }

  _audioPlayingSection() {
    final _recordProvider = ref.read(RecordAudio);

    return Container(
      width: MediaQuery.of(context).size.width - 110,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _audioControllingSection(_recordProvider.recordedFilePath),
          _audioProgressSection(),
        ],
      ),
    );
  }

  _audioControllingSection(String songPath) {
    final _playProvider = ref.read(PlayAudio);

    return IconButton(
      onPressed: () async {
        if (songPath.isEmpty) return;

        await _playProvider.playAudio(File(songPath));
      },
      icon: Icon(
          _playProvider.isSongPlaying ? Icons.pause : Icons.play_arrow_rounded),
      color: const Color(0xff4BB543),
      iconSize: 30,
    );
  }

  _audioProgressSection() {
    final _playProvider = ref.read(PlayAudio);

    return Expanded(
        child: Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: LinearPercentIndicator(
        percent: _playProvider.currLoadingStatus,
        backgroundColor: Colors.black26,
        progressColor: const Color(0xff4BB543),
      ),
    ));
  }

  _resetButton() {
    final _recordProvider = ref.read(RecordAudio);
    return InkWell(
      onTap: () => _recordProvider.clearOldData(),
      child: Center(
        child: Container(
          width: 80,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Reset',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
