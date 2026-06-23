import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/design_system.dart';
import '../../../core/theme/app_color_palettes.dart';
import '../../../data/models/voice_note_model.dart';

class VoiceNoteRecorder extends StatefulWidget {
  final Function(VoiceNoteModel) onRecorded;

  const VoiceNoteRecorder({super.key, required this.onRecorded});

  @override
  State<VoiceNoteRecorder> createState() => _VoiceNoteRecorderState();
}

class _VoiceNoteRecorderState extends State<VoiceNoteRecorder> {
  late final AudioRecorder _audioRecorder;
  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _timer;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/${const Uuid().v4()}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _startTime = DateTime.now();
        });

        _startTimer();
      }
    } catch (e) {
      debugPrint('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _timer?.cancel();

      setState(() {
        _isRecording = false;
      });

      if (path != null && _startTime != null) {
        final file = File(path);
        if (await file.exists()) {
          final note = VoiceNoteModel(
            id: const Uuid().v4(),
            downloadUrl: '', // Will be set after upload
            durationSeconds: _recordDuration,
            recordedAt: _startTime!,
            localPath: path,
          );
          widget.onRecorded(note);
        }
      }
    } catch (e) {
      debugPrint('Error stopping record: $e');
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }
    return numberStr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Container(
      padding: const EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: DS.borderRadiusMd,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isRecording
                    ? theme.colorScheme.error
                    : theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording
                    ? theme.colorScheme.onError
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: DS.md),
          if (_isRecording)
            Text(
              '$minutes:$seconds',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Text(
              'Tap to record voice note',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const Spacer(),
          if (_isRecording)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: SemanticColors.errorRed,
              ),
            ),
        ],
      ),
    );
  }
}
