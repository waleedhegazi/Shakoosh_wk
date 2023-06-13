import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shakoosh_wk/data_models/User_Account_Model.dart';
import 'package:shakoosh_wk/repository/Authentication_Repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

//Do database operations
class UserRepository {
  static final _db = FirebaseFirestore.instance;
  static final userId = AuthenticationRepository.auth.currentUser!.uid;

  static UserAccountModel _currentUser = Accounts.dummyAccount;
  static UserAccountModel getCurrentUser() {
    return _currentUser;
  }

  static Future updateCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('service_provider')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      _currentUser = UserAccountModel.fromJson(value.data()!);
    }).catchError((e) {
      print("Errrrrrror ${e.toString()}");
    });
  }

  static Future<bool> createUser(UserAccountModel user) async {
    bool isCreated = await AuthenticationRepository.createUser(user);
    return isCreated;
  }

  static Future<void> addProfilePic(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("worker_images")
        .child("$userId.jpg");
    await storageRef.putFile(image);
    final imageURL = await storageRef.getDownloadURL();
    getCurrentUser().setProfilePicURL(imageURL);
    getCurrentUser().setProfilePic(imageURL);
    await _db
        .collection('service_provider')
        .doc(userId)
        .update({'profile_pic_url': imageURL});
  }

  static Future<void> removeProfilePic() async {
    getCurrentUser().setProfilePicURL(null);
    await FirebaseStorage.instance
        .ref()
        .child("worker_images")
        .child("$userId.jpg")
        .delete();
    await _db
        .collection('service_provider')
        .doc(userId)
        .update({'profile_pic_url': null});
  }

  static Future<void> updateLocationInDatabase() async {
    await _db
        .collection('service_provider')
        .doc(userId)
        .update({'location': getCurrentUser().getLocation().toJson()});
  }

  static Future<void> updateProfileInfoInDatabase() async {
    await _db.collection('service_provider').doc(userId).update({
      'first_name': getCurrentUser().getFirstName(),
      'last_name': getCurrentUser().getLastName(),
      'email': getCurrentUser().getEmail(),
      'password': getCurrentUser().getPassword(),
      'phone_number': getCurrentUser().getPhoneNumber()
    });
  }

  static Future<void> updateTimeTableInDatabase() async {
    await _db.collection('service_provider').doc(userId).update({
      'time_table': getCurrentUser().getTimeTable(),
    });
  }
}
