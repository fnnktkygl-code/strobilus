import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';
import '../../../core/theme/app_color_palettes.dart';
import '../../../data/models/voice_note_model.dart';

class VoiceNotePlayer extends StatefulWidget {
  final VoiceNoteModel voiceNote;
  final VoidCallback? onDelete;

  const VoiceNotePlayer({super.key, required this.voiceNote, this.onDelete});

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Set source
    if (widget.voiceNote.localPath != null) {
      _audioPlayer.setSourceDeviceFile(widget.voiceNote.localPath!);
    } else if (widget.voiceNote.downloadUrl.isNotEmpty) {
      _audioPlayer.setSourceUrl(widget.voiceNote.downloadUrl);
    }

    // Listeners
    _durationSubscription = _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    _playerStateChangeSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = widget.voiceNote.downloadUrl.isNotEmpty;
    final isLocalOnly =
        widget.voiceNote.localPath != null &&
        widget.voiceNote.downloadUrl.isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: DS.sm),
      padding: const EdgeInsets.symmetric(horizontal: DS.md, vertical: DS.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: DS.borderRadiusMd,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            ),
            color: theme.colorScheme.primary,
            iconSize: 36,
            onPressed: () {
              if (_isPlaying) {
                _audioPlayer.pause();
              } else {
                _audioPlayer.resume();
              }
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.voiceNote.recordedAt.toString().substring(
                        0,
                        16,
                      ), // YYYY-MM-DD HH:MM
                      style: theme.textTheme.labelSmall,
                    ),
                    if (isLocalOnly)
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 14,
                        color: SemanticColors.warningOchre,
                      )
                    else if (isOnline)
                      const Icon(
                        Icons.cloud_done,
                        size: 14,
                        color: SemanticColors.successLeaf,
                      ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inMilliseconds.toDouble() > 0
                        ? _duration.inMilliseconds.toDouble()
                        : 1.0,
                    value: _position.inMilliseconds.toDouble().clamp(
                      0.0,
                      _duration.inMilliseconds.toDouble() > 0
                          ? _duration.inMilliseconds.toDouble()
                          : 1.0,
                    ),
                    onChanged: (val) {
                      _audioPlayer.seek(Duration(milliseconds: val.toInt()));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: theme.textTheme.labelSmall,
                    ),
                    Text(
                      _formatDuration(
                        _duration > Duration.zero
                            ? _duration
                            : Duration(
                                seconds: widget.voiceNote.durationSeconds,
                              ),
                      ),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: theme.colorScheme.error,
              onPressed: widget.onDelete,
            ),
        ],
      ),
    );
  }
}
