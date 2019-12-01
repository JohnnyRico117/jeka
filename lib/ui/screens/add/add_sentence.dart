import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/state_widget.dart';

class AddSentence extends StatefulWidget {

  String folderID;

  AddSentence(this.folderID);

  @override
  _AddSentenceState createState() => _AddSentenceState();
}

class _AddSentenceState extends State<AddSentence> {

  StateModel appState;

  final _formKey = GlobalKey<FormState>();

  String _vocab = '';
  String _translate = '';
//  String _date = '';
//  String _points = '';

//  var txt = new TextEditingController();
//  DateFormat format = new DateFormat("dd.MM.yyyy 'at' hh:mm");

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Add a new sentence')
      ),
      body: new ListView(

        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      hintText: 'Enter german sentence...',
                      contentPadding: const EdgeInsets.all(16.0)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter german sentence';
                    } else {
                      setState(() {
                        _vocab = value;
                      });
                    }
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                      hintText: 'Enter russian translate...',
                      contentPadding: const EdgeInsets.all(16.0)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter russian translation';
                    } else {
                      setState(() {
                        _translate = value;
                      });
                    }
                  },
                )
              ],
            ),
          ),

          RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                DocumentReference docRef = Firestore.instance.collection('sentences').document();
                docRef.setData({
                  'german' : _vocab,
                  'russian': _translate,
//                  'Done': false,
//                  'Date': _date,
//                  'Points': int.parse(_points),
//                  'ReceiverID': appState.user.uid,
//                  'Status': 0,
//                  'HappyStatus': 0,
//                  'FolderID': widget.folderID
                });

                print("ID: " + docRef.documentID.toString());

                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}