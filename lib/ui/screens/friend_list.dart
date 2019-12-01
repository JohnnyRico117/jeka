import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/state_widget.dart';
import 'package:jeka/ui/screens/add/add_friend.dart';
import 'package:jeka/ui/widgets/loading_indicator.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  StateModel appState;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: new StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return LoadingIndicator();
                return new ListView(
                  children: snapshot.data.documents
                      .where((d) => appState.currentUser.friends != null && appState.currentUser.friends.contains(d.documentID))
                      .map((document) {
                    return _buildFriend(document);
                  }).toList(),
                );
              },
            ),
          ),
          ListTile(
            leading: new FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFriend()),
                  );
                },
                child: Icon(Icons.add)
            ),
            title: new Text("Add Friend"),
          ),
        ],
      ),
    );
  }

  Widget _buildFriend(DocumentSnapshot document) {
    return ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage(document['userpic']),
        radius: 30.0,
      ),
      title: new Text(document['username']),

    );
  }



}