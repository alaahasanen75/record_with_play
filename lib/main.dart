import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:record_with_play/providers/play_audio_provider.dart';
import 'package:record_with_play/providers/record_audio_provider.dart';
import 'package:record_with_play/screens/record_and_play_audio.dart';

void main() {
  final containar = ProviderContainer();
  containar.read(PlayAudio);
  containar.read(RecordAudio);

  runApp(
    UncontrolledProviderScope(container: containar, child: const EntryRoot()),
  );
}

class EntryRoot extends StatelessWidget {
  const EntryRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Record and Play',
      home: RecordAndPlayScreen(),
    );
  }
}
