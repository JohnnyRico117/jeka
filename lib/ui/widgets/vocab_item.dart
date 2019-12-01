import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/state_widget.dart';

import 'package:jeka/ui/screens/edit/edit_vocab.dart';

class VocabItem extends StatefulWidget {

  DocumentSnapshot snap;

  VocabItem(this.snap);

  @override
  _VocabItemState createState() => _VocabItemState();

}

class _VocabItemState extends State<VocabItem> {

  StateModel appState;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    final int status = 1;
    final int happyStatus = 2;

    return Card(
        color: Colors.white,
        elevation: 10.0,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
//                leading: Stack(
//                    children: <Widget>[
//                      Container(
//                        width: 50.0,
//                        decoration: BoxDecoration(
//                            color: _circleColor,
//                            shape: BoxShape.circle
//                        ),
//                      ),
//                      Positioned.fill(
//                          child: Center(
//                            child: Text(widget.snap.data['points'].toString(), style: _boldFont),
//                          )
//                      )
//                    ]
//                ),
                title: Text(
                    appState.currentUser.language == "German" ? widget.snap.data['german'] : widget.snap.data['russian'],
                    style: _biggerFont
                ),
                subtitle: Text(
                    appState.currentUser.language == "German" ? widget.snap.data['russian'] : widget.snap.data['german'],
                    style: _smallerFont
                ),
                trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditVocab(widget.snap.documentID)),
                      );
                      print("Click");
                    }),
              )
            ],
          ),
        )
    );

  }

}