import 'package:hive/hive.dart';

part 'voice_note_model.g.dart';

/// A voice note recorded for a pine cone.
@HiveType(typeId: 3)
class VoiceNoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String downloadUrl;

  @HiveField(2)
  final int durationSeconds;

  @HiveField(3)
  final DateTime recordedAt;

  @HiveField(4)
  final String? localPath;

  VoiceNoteModel({
    required this.id,
    required this.downloadUrl,
    required this.durationSeconds,
    required this.recordedAt,
    this.localPath,
  });

  factory VoiceNoteModel.fromFirestore(Map<String, dynamic> data, String id) {
    return VoiceNoteModel(
      id: id,
      downloadUrl: data['downloadUrl'] as String? ?? '',
      durationSeconds: data['durationSeconds'] as int? ?? 0,
      recordedAt:
          DateTime.tryParse(data['recordedAt']?.toString() ?? '') ??
          DateTime.now(),
      localPath: data['localPath'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'downloadUrl': downloadUrl,
      'durationSeconds': durationSeconds,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  /// Format duration as mm:ss.
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
