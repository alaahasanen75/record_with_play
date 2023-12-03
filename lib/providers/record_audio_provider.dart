import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:record_with_play/services/permission_management.dart';
import 'package:record_with_play/services/storage_management.dart';
import 'package:record_with_play/services/toast_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final RecordAudio =
    ChangeNotifierProvider<RecordAudioProvider>((ref) => RecordAudioProvider());

class RecordAudioProvider extends ChangeNotifier {
  final Record _record = Record();
  bool _isRecording = false;
  Color backgroungcolor = Colors.black.withOpacity(.0);
  String _afterRecordingFilePath = '';

  bool get isRecording => _isRecording;
  String get recordedFilePath => _afterRecordingFilePath;

  clearOldData() {
    _afterRecordingFilePath = '';
    notifyListeners();
  }

  recordVoice() async {
    final _isPermitted = (await PermissionManagement.recordingPermission()) &&
        (await PermissionManagement.storagePermission());

    if (!_isPermitted) return;

    if (!(await _record.hasPermission())) return;

    final _voiceDirPath = await StorageManagement.getAudioDir;
    final _voiceFilePath = StorageManagement.createRecordAudioPath(
        dirPath: _voiceDirPath, fileName: 'audio_message');

    await _record.start(path: _voiceFilePath);
    _isRecording = true;
    backgroungcolor = Colors.black.withOpacity(.5);
    notifyListeners();

    showToast('Recording Started');
  }

  stopRecording() async {
    String? _audioFilePath;

    if (await _record.isRecording()) {
      _audioFilePath = await _record.stop();
      backgroungcolor = Colors.black.withOpacity(.0);
      showToast('Recording Stopped');
    }

    print('Audio file path: $_audioFilePath');

    _isRecording = false;
    _afterRecordingFilePath = _audioFilePath ?? '';
    notifyListeners();
  }
}
