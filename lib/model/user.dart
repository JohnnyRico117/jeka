import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  int points;
  String language;
  List<String> friends;
  //List<String> projects;

  User({
    this.id,
    this.points,
    this.language = "Russian",
    this.friends,
    //this.projects
  });

  User.fromSnap(DocumentSnapshot snap)
      : this(
      id: snap.data.containsKey('id') ? snap.data['id'] : '',
      points: snap.data.containsKey('points') ? snap.data['points'] : '',
      friends: (snap.data.containsKey('friends') && snap.data['friends'] is List) ? new List<String>.from(snap.data['friends']) : null,
      //projects: (snap.data.containsKey('projects') && snap.data['projects'] is List) ? new List<String>.from(snap.data['projects']) : null,
  );

}