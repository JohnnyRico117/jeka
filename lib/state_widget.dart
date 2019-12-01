import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/model/user.dart';
import 'package:jeka/utils/auth.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
    as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();


  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }



  Future<User> getUser() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists) {
      return User.fromSnap(querySnapshot);
    }
    return null;
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
    }

    FirebaseUser firebaseUser = await firebaseGoogleSignIn(googleAccount);
    state.user = firebaseUser;

    if (firebaseUser != null) {

      final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        state.newuser = true;
        Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'id': firebaseUser.uid,
          'username': firebaseUser.displayName,
          'userpic': firebaseUser.photoUrl,
          'points': 0,
          'friends': new List<String>(),
          //'projects': new List<String>(),
        });
      }

      User theUser = await getUser();

      setState(() {
        state.isLoading = false;
        state.currentUser = theUser;
      });
    }
  }

  Future<Null> signOutOfGoogle() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    googleAccount = null;
    state.user = null;
    setState(() {
      state = StateModel(user: null);
    });
  }


  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}