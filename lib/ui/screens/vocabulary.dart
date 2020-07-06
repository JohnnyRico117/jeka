import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/state_widget.dart';

import 'package:jeka/ui/widgets/vocab_item.dart';
import 'package:jeka/ui/widgets/loading_indicator.dart';

import 'package:jeka/ui/screens/add/add_vocab.dart';

class VocabList extends StatefulWidget {

  @override
  _VocabListState createState() => _VocabListState();
}

class _VocabListState extends State<VocabList> {
  StateModel appState;

  String _sortby;
  List<String> _phaseFilter = new List();
  bool filter1 = false;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _sortby = _dropDownMenuItems[0].value;
  }

  List _sortType = ['Deutsches Alphabet', 'Русский алфавит'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sort in _sortType) {
      items.add(new DropdownMenuItem(
          value: sort,
          child: new Text(sort)
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedSort) {
    if (this.mounted) {
      setState(() {
        _sortby = selectedSort;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Sort by: "),
                DropdownButton(
                    value: _sortby,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem
                ),
              ],
            ),
            Expanded(
              child: new StreamBuilder(
                stream: Firestore.instance.collection('vocabulary').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return LoadingIndicator();
                  switch(_sortby) {
                    case 'Deutsches Alphabet':
                      snapshot.data.documents.sort((a, b) => a['german'].toString().toLowerCase().compareTo(b['german'].toString().toLowerCase()));
                      break;
                    case 'Русский алфавит':
                      snapshot.data.documents.sort((a, b) => a['russian'].toString().toLowerCase().compareTo(b['russian'].toString().toLowerCase()));
                      break;
                    default:
                      snapshot.data.documents.sort((a, b) => a['german'].toString().toLowerCase().compareTo(b['german'].toString().toLowerCase()));
                      break;
                  }
                  if (_phaseFilter.isEmpty) {
                    return new ListView(
                      children: snapshot.data.documents
                          .map((document) {
                        return VocabItem(document);
                      }).toList(),
                    );
                  } else {
                    return new ListView(
                      children: snapshot.data.documents
                          .where((d) => _phaseFilter.contains(d.data['phase']))
                          .map((document) {
                        return VocabItem(document);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddVocab("")),
            );
          },
          child: Icon(Icons.add)
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}