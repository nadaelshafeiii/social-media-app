import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/domain/auth_repo.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebabsefirestore = FirebaseFirestore.instance;
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userDoc = await firebabsefirestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();

      //create user
      AppUser user = AppUser(
          uid: userCredential.user!.uid, email: email, name: userDoc['name']);

      return user;
    } catch (e) {
      throw Exception('Login Failed : $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //create user
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      await firebabsefirestore
          .collection('Users')
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Login Failed : $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    DocumentSnapshot userDoc = await firebabsefirestore
        .collection('Users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDoc.exists) {
      return null;
    }

    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: userDoc['name']);
  }
  
  @override
  Future<AppUser> fetchUserById(String userId) async {
    try {
      final doc = await firebabsefirestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data()!);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
}
