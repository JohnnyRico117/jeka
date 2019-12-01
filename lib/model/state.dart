import 'package:firebase_auth/firebase_auth.dart';
import 'package:jeka/model/user.dart';

class StateModel {
  bool isLoading;
  FirebaseUser user;
  bool newuser;
  User currentUser;


  StateModel({
    this.isLoading = false,
    this.user,
    this.newuser,
    this.currentUser,
  });
}