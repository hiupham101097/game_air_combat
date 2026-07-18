import 'package:firebase_database/firebase_database.dart';
import 'package:mini__game2/controller/auth_controller.dart';

class CloudSyncService {
  static final CloudSyncService _instance = CloudSyncService._internal();
  factory CloudSyncService() => _instance;
  CloudSyncService._internal();

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: 'https://game-fly-air-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );

  Future<void> pushData(Map<String, dynamic> data) async {
    final user = AuthController().currentUser;
    if (user == null) return; // Need to be logged in to sync

    try {
      await _database.ref('users/${user.uid}').update(data);
    } catch (e) {
      print("Error pushing to cloud: $e");
    }
  }

  Future<Map<String, dynamic>?> pullData() async {
    final user = AuthController().currentUser;
    if (user == null) return null;

    try {
      final snapshot = await _database.ref('users/${user.uid}').get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
      }
    } catch (e) {
      print("Error pulling from cloud: $e");
    }
    return null;
  }
}
