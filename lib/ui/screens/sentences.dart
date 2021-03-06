import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/state_widget.dart';

import 'package:jeka/ui/widgets/sentence_item.dart';
import 'package:jeka/ui/widgets/loading_indicator.dart';

import 'package:jeka/ui/screens/add/add_sentence.dart';

class SentenceList extends StatefulWidget {

  @override
  _SentenceListState createState() => _SentenceListState();
}

class _SentenceListState extends State<SentenceList> {
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

    return Padding(
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
//              Text("Filter:"),
//              Text("1:"),
//              Checkbox(
//                  value: filter1,
//                  onChanged: (bool value) {
//                    List<String> _temp = new List();
//                    if (this.mounted) {
//                      setState(() {
//                        if (filter1) {
//                          //_temp.add("VhrdI7VVMjfDhoOBmODU");
//                          //_phaseFilter = _temp;
//                          _phaseFilter.add("VhrdI7VVMjfDhoOBmODU");
//                        } else {
//                          _phaseFilter.remove("VhrdI7VVMjfDhoOBmODU");
//                        }
//                      });
//                    }
//                    print(_phaseFilter);
//                  }
//              ),
//              Text("2:"),
//              Checkbox(
//                  value: false,
//                  onChanged: null
//              )
            ],
          ),
          Expanded(
            child: new StreamBuilder(
              stream: Firestore.instance.collection('sentences').snapshots(),
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
                      return SentenceItem(document);
                    }).toList(),
                  );
                } else {
                  return new ListView(
                    children: snapshot.data.documents
                        .where((d) => _phaseFilter.contains(d.data['phase']))
                        .map((document) {
                      return SentenceItem(document);
                    }).toList(),
                  );
                }
              },
            ),
          ),
          ListTile(
            leading: new FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSentence("")),
                  );
                },
                child: Icon(Icons.add)
            ),
            title: new Text("New sentence"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}