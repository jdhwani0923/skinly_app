import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  FirebaseFirestore? _db;

  DatabaseService() {
    try {
      _db = FirebaseFirestore.instance;
    } catch (e) {
      debugPrint('Firestore unavailable, running without it: $e');
    }
  }

  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await _db?.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db?.collection('users').doc(uid).get();
    return doc?.data();
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db?.collection('users').doc(uid).update(data);
  }

  Future<void> updateSkinProfile(String uid, Map<String, dynamic> skinData) async {
    await _db
        ?.collection('users')
        .doc(uid)
        .collection('skin_profiles')
        .doc('current')
        .set(skinData, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getSkinProfile(String uid) async {
    final doc = await _db
        ?.collection('users')
        .doc(uid)
        .collection('skin_profiles')
        .doc('current')
        .get();
    return doc?.data();
  }

  Future<void> saveRoutine(String uid, Map<String, dynamic> routineData) async {
    await _db?.collection('users').doc(uid).collection('routines').add(routineData);
  }

  Stream<QuerySnapshot> getRoutines(String uid) {
    return _db
            ?.collection('users')
            .doc(uid)
            .collection('routines')
            .orderBy('createdAt', descending: true)
            .snapshots() ??
        const Stream.empty();
  }

  Future<void> updateRoutineStep(
      String uid, String routineId, int stepIndex, bool done) async {
    if (_db == null) return;
    final docRef =
        _db!.collection('users').doc(uid).collection('routines').doc(routineId);
    final doc = await docRef.get();
    if (doc.exists) {
      final routine = doc.data();
      if (routine != null && routine.containsKey('steps')) {
        final steps = List.from(routine['steps']);
        steps[stepIndex]['done'] = done;
        await docRef.update({'steps': steps});
      }
    }
  }

  Future<void> logProgress(String uid, Map<String, dynamic> progressData) async {
    await _db?.collection('users').doc(uid).collection('progress_history').add(progressData);
  }

  Stream<QuerySnapshot> getProgressHistory(String uid) {
    return _db
            ?.collection('users')
            .doc(uid)
            .collection('progress_history')
            .orderBy('date', descending: true)
            .snapshots() ??
        const Stream.empty();
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    if (_db == null) return [];
    final snapshot = await _db!.collection('users').get();
    return snapshot.docs.map((doc) => {'uid': doc.id, ...doc.data()}).toList();
  }
}
