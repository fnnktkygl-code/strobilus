import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/pine_cone_model.dart';
import '../../models/user_model.dart';

/// Service for all Firestore CRUD operations.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // === USERS ===

  Future<UserModel?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toFirestore());
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }

  // === PINE CONES ===

  Future<List<PineConeModel>> getUserCones(String userId) async {
    final snapshot = await _db
        .collection('pine_cones')
        .where('userId', isEqualTo: userId)
        .orderBy('collectedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PineConeModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<PineConeModel?> getCone(String coneId) async {
    final doc = await _db.collection('pine_cones').doc(coneId).get();
    if (!doc.exists) return null;
    return PineConeModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> addCone(PineConeModel cone) async {
    await _db.collection('pine_cones').doc(cone.id).set(cone.toFirestore());
  }

  Future<void> updateCone(PineConeModel cone) async {
    await _db.collection('pine_cones').doc(cone.id).update(cone.toFirestore());
  }

  Future<void> deleteCone(String coneId) async {
    // Delete voice notes sub-collection first
    final voiceNotes = await _db
        .collection('pine_cones')
        .doc(coneId)
        .collection('voice_notes')
        .get();
    for (final doc in voiceNotes.docs) {
      await doc.reference.delete();
    }
    await _db.collection('pine_cones').doc(coneId).delete();
  }

  // === VOICE NOTES ===

  Future<void> addVoiceNote(
    String coneId,
    Map<String, dynamic> voiceNoteData,
    String voiceNoteId,
  ) async {
    await _db
        .collection('pine_cones')
        .doc(coneId)
        .collection('voice_notes')
        .doc(voiceNoteId)
        .set(voiceNoteData);
  }

  Future<void> deleteVoiceNote(String coneId, String voiceNoteId) async {
    await _db
        .collection('pine_cones')
        .doc(coneId)
        .collection('voice_notes')
        .doc(voiceNoteId)
        .delete();
  }

  Future<List<Map<String, dynamic>>> getVoiceNotes(String coneId) async {
    final snapshot = await _db
        .collection('pine_cones')
        .doc(coneId)
        .collection('voice_notes')
        .get();
    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  // === USER STATS (update after cone operations) ===

  Future<void> updateUserStats(
    String userId, {
    int? totalCones,
    int? uniqueSpeciesCount,
    int? countriesCount,
  }) async {
    final updates = <String, dynamic>{
      'lastActivityAt': FieldValue.serverTimestamp(),
    };
    if (totalCones != null) updates['totalCones'] = totalCones;
    if (uniqueSpeciesCount != null) {
      updates['uniqueSpeciesCount'] = uniqueSpeciesCount;
    }
    if (countriesCount != null) updates['countriesCount'] = countriesCount;

    await _db.collection('users').doc(userId).update(updates);
  }

  // === DELETE ALL USER DATA (GDPR) ===

  Future<void> deleteAllUserData(String userId) async {
    // Delete all pine cones
    final cones = await _db
        .collection('pine_cones')
        .where('userId', isEqualTo: userId)
        .get();
    for (final doc in cones.docs) {
      await deleteCone(doc.id);
    }
    // Delete user document
    await deleteUser(userId);
  }
}
