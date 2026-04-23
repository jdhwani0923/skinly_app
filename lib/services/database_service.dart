import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // USER PROFILE
  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // SKIN PROFILES
  Future<void> updateSkinProfile(String uid, Map<String, dynamic> skinData) async {
    await _db.collection('users').doc(uid).collection('skin_profiles').doc('current').set(skinData, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getSkinProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).collection('skin_profiles').doc('current').get();
    return doc.data();
  }

  // ROUTINES
  Future<void> saveRoutine(String uid, Map<String, dynamic> routineData) async {
    await _db.collection('users').doc(uid).collection('routines').add(routineData);
  }

  Stream<QuerySnapshot> getRoutines(String uid) {
    return _db.collection('users').doc(uid).collection('routines').orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> updateRoutineStep(String uid, String routineId, int stepIndex, bool done) async {
    final docRef = _db.collection('users').doc(uid).collection('routines').doc(routineId);
    final doc = await docRef.get();
    if (doc.exists) {
      final routine = doc.data();
      if (routine != null && routine.containsKey('steps')) {
        List steps = List.from(routine['steps']);
        steps[stepIndex]['done'] = done;
        await docRef.update({'steps': steps});
      }
    }
  }

  // PROGRESS HISTORY
  Future<void> logProgress(String uid, Map<String, dynamic> progressData) async {
    await _db.collection('users').doc(uid).collection('progress_history').add(progressData);
  }

  Stream<QuerySnapshot> getProgressHistory(String uid) {
    return _db.collection('users').doc(uid).collection('progress_history').orderBy('date', descending: true).snapshots();
  }

  // ADMIN
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) => {'uid': doc.id, ...doc.data()}).toList();
  }
}
