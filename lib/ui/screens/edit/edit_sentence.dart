import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/state_widget.dart';

class EditSentence extends StatefulWidget {

  String vocabID;

  EditSentence(this.vocabID);

  @override
  _EditSentenceState createState() => _EditSentenceState();
}

class _EditSentenceState extends State<EditSentence> {

  StateModel appState;

  final _formKey = GlobalKey<FormState>();

  String _german = '';
  String _russian = '';
//  String _date = '';
//  String _points = '';

  TextEditingController germanController = TextEditingController(text: "");
  TextEditingController russianController = TextEditingController(text: "");

//  var txt = new TextEditingController();
//  DateFormat format = new DateFormat("dd.MM.yyyy 'at' hh:mm");

  @override
  void initState() {
    super.initState();
    germanController.text = _german;
    russianController.text = _russian;
    initVocabs();
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Edit sentence')
      ),
      body: new ListView(

        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: germanController,
                  autofocus: true,
                  decoration: new InputDecoration(
                      hintText: _german,
                      contentPadding: const EdgeInsets.all(16.0)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter german sentence';
                    } else {
                      setState(() {
                        _german = value;
                      });
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: russianController,
                  decoration: new InputDecoration(
                      hintText: _russian,
                      contentPadding: const EdgeInsets.all(16.0)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter russian translation';
                    } else {
                      setState(() {
                        _russian = value;
                      });
                      return null;
                    }
                  },
                )
              ],
            ),
          ),

          RaisedButton(
            child: Text("Save"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                final DocumentReference postRef = Firestore.instance.collection('sentences').document(widget.vocabID);
                Firestore.instance.runTransaction((Transaction tx) async {
                  DocumentSnapshot postSnapshot = await tx.get(postRef);
                  if (postSnapshot.exists) {
                    await tx.update(postRef, <String, dynamic>{
                      'german' : _german,
                      'russian': _russian,
                    });
                  }
                });
                Navigator.pop(context);
              }
            },
          ),
          RaisedButton(
            child: Text("Delete"),
            onPressed: () {
              final DocumentReference postRef = Firestore.instance.collection('sentences').document(widget.vocabID);
              Firestore.instance.runTransaction((Transaction tx) async {
                DocumentSnapshot postSnapshot = await tx.get(postRef);
                if (postSnapshot.exists) {
                  await tx.delete(postRef);
                }
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }


  void initVocabs() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('sentences')
        .document(widget.vocabID)
        .get();
    if (querySnapshot.exists) {
      setState(() {
        _german = querySnapshot.data['german'];
        _russian = querySnapshot.data['russian'];
        germanController.text = _german;
        russianController.text = _russian;
      });

    }
  }
}