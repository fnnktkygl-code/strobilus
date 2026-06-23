import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

/// Service for Firebase Storage operations (photos + audio).
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const _uuid = Uuid();

  /// Upload a cone photo. Returns the download URL.
  Future<String> uploadConePhoto({
    required String coneId,
    required File imageFile,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final fileName = '${_uuid.v4()}.jpg';
    final ref = _storage.ref('users/$userId/cones/$coneId/$fileName');

    await ref.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));

    return await ref.getDownloadURL();
  }

  /// Upload a user avatar. Returns the download URL.
  Future<String> uploadUserAvatar({required Uint8List imageBytes}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = _storage.ref('users/$userId/avatar.jpg');

    await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

    return await ref.getDownloadURL();
  }

  /// Upload a user banner. Returns the download URL.
  Future<String> uploadUserBanner({required Uint8List imageBytes}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = _storage.ref('users/$userId/banner.jpg');

    await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

    return await ref.getDownloadURL();
  }

  /// Upload a user background. Returns the download URL.
  Future<String> uploadUserBackground({required Uint8List imageBytes}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = _storage.ref('users/$userId/background.jpg');

    await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

    return await ref.getDownloadURL();
  }

  /// Upload a user custom species illustration. Returns the download URL.
  Future<String> uploadSpeciesIllustration({
    required String speciesId,
    required Uint8List imageBytes,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = _storage.ref('users/$userId/species_photos/$speciesId.jpg');

    await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

    return await ref.getDownloadURL();
  }

  /// Upload a voice note. Returns the download URL.
  Future<String> uploadVoiceNote({
    required String coneId,
    required File audioFile,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final fileName = '${_uuid.v4()}.m4a';
    final ref = _storage.ref('users/$userId/cones/$coneId/audio/$fileName');

    await ref.putFile(audioFile, SettableMetadata(contentType: 'audio/mp4'));

    return await ref.getDownloadURL();
  }

  /// Delete a file by its download URL.
  Future<void> deleteFile(String downloadUrl) async {
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } catch (_) {
      // Ignore if file already deleted
    }
  }

  /// Delete all files for a cone.
  Future<void> deleteConeFiles(String coneId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = _storage.ref('users/$userId/cones/$coneId');

    try {
      final result = await ref.listAll();
      for (final item in result.items) {
        await item.delete();
      }
      // Also delete audio subfolder
      final audioRef = ref.child('audio');
      try {
        final audioResult = await audioRef.listAll();
        for (final item in audioResult.items) {
          await item.delete();
        }
      } catch (_) {}
    } catch (_) {}
  }

  /// Delete the user's avatar.
  Future<void> deleteUserAvatar(String userId) async {
    final ref = _storage.ref('users/$userId/avatar.jpg');
    try {
      await ref.delete();
    } catch (_) {}
  }

  /// Delete the user's banner.
  Future<void> deleteUserBanner(String userId) async {
    final ref = _storage.ref('users/$userId/banner.jpg');
    try {
      await ref.delete();
    } catch (_) {}
  }
}
