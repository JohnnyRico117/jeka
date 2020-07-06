import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/ui/widgets/vocab_card.dart';
import 'package:jeka/ui/widgets/loading_indicator.dart';

class VocabCards extends StatefulWidget {
  @override
  _VocabCardsState createState() => _VocabCardsState();
}

class _VocabCardsState extends State<VocabCards> {

  List<DocumentSnapshot> toLearn = new List();
  bool russianToGerman;
  //bool learnVocabs;
  String whatToLearn = "Vocabs";
  //String limit = "10";
  bool done;

  @override
  void initState() {
    super.initState();
    russianToGerman = true;
    done = false;
    //learnVocabs = true;
    getVocabs();
  }

  void getVocabs() async {
    List<DocumentSnapshot> list = new List();
    QuerySnapshot querySnapshot = await Firestore.instance.collection('vocabulary').getDocuments();
//    if (limit == "No limit") {
//      querySnapshot = await Firestore.instance.collection('vocabulary').getDocuments();
//    } else {
//      querySnapshot = await Firestore.instance.collection('vocabulary').limit(int.parse(limit)).getDocuments();
//    }
    list = querySnapshot.documents;
    list.shuffle();

    setState(() {
      toLearn = list;
    });
  }

  void getSentences() async {

    List<DocumentSnapshot> list = new List();
    QuerySnapshot querySnapshot = await Firestore.instance.collection('sentences').getDocuments();
    list = querySnapshot.documents;
    list.shuffle();

//    if (limit == "No limit") {
//      QuerySnapshot querySnapshot = await Firestore.instance.collection('sentences').getDocuments();
//      list = querySnapshot.documents;
//      list.shuffle();
//    } else {
//      QuerySnapshot querySnapshot = await Firestore.instance.collection('sentences').limit(int.parse(limit)).getDocuments();
//      list = querySnapshot.documents;
//      list.shuffle();
//    }

    setState(() {
      toLearn = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                value: whatToLearn,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  setState(() {
                    whatToLearn = newValue;
                    toLearn = new List();
                    if(whatToLearn == "Vocabs") {
                      getVocabs();
                    } else {
                      getSentences();
                    }
                  });
                },
                items: <String>['Vocabs', 'Sentences']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 8.0),
//                child: DropdownButton<String>(
//                  value: limit,
//                  icon: Icon(Icons.arrow_drop_down),
//                  iconSize: 24,
//                  elevation: 16,
//                  onChanged: (String newValue) {
//                    setState(() {
//                      limit = newValue;
//                      toLearn = new List();
//                      if(whatToLearn == "Vocabs") {
//                        getVocabs();
//                      } else {
//                        getSentences();
//                      }
//                    });
//                  },
//                  items: <String>['10', '20', '30', 'No limit']
//                      .map<DropdownMenuItem<String>>((String value) {
//                    return DropdownMenuItem<String>(
//                      value: value,
//                      child: Text(value),
//                    );
//                  }).toList(),
//                ),
//              ),
            ],
          ),

          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(russianToGerman ? "RUSSIAN" : "GERMAN", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),),
                  Icon(Icons.swap_horiz, color: Colors.black,),
                  Text(russianToGerman ? "GERMAN" : "RUSSIAN", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                toLearn = new List();
                russianToGerman = !russianToGerman;
                if(whatToLearn == "Vocabs") {
                  getVocabs();
                } else {
                  getSentences();
                }
              });
            },
          ),
          Expanded(child: getLearnCards()),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  iconSize: 60.0,
                  icon: Icon(Icons.cancel, color: Colors.red,),
                  onPressed: () {
                    setState(() {
                      toLearn.last.reference.updateData({
                        'known': FieldValue.increment(-1)
                      });
                      toLearn.removeLast();
                      if (toLearn.isEmpty) {
                        done = true;
                      }
                    });
                  },
                ),
//              IconButton(
//                iconSize: 50.0,
//                icon: Icon(Icons.swap_horizontal_circle, color: Colors.blue,),
//                onPressed: () {
//                  setState(() {
//                    toLearn.removeLast();
//                    if (toLearn.isEmpty) {
//                      done = true;
//                    }
//                  });
//                },
//              ),
                IconButton(
                  iconSize: 60.0,
                  icon: Icon(Icons.check_circle, color: Colors.green,),
                  onPressed: () {
                    setState(() {
                      toLearn.last.reference.updateData({
                        'known': FieldValue.increment(1)
                      });

                      bool delete = false;

                      DocumentReference reference = toLearn.last.reference;

                      print(toLearn.last.data['known'].toString());

                      if (toLearn.last.data['known'] != null && toLearn.last.data['known'] > 5) {
                        delete = true;
                      }
                      toLearn.removeLast();

                      if (delete) {
                        reference.delete();
                      }

                      if (toLearn.isEmpty) {
                        done = true;
                      }
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getLearnCards() {

    if (toLearn.isEmpty && !done) {
      return LoadingIndicator();
    } else if (toLearn.isEmpty && done) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("YAAAY, You're done", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30.0
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text("Want to start again?", style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),),
          ),
          FlatButton(
            color: Colors.blue,
            child: Text("LET'S GO", style: TextStyle(
              color: Colors.white
            ),),
            onPressed: () {
              if(whatToLearn == "Vocabs") {
                getVocabs();
              } else {
                getSentences();
              }
              setState(() {
                done = false;
              });
            },
          )
        ],
      );
    } else {
      return Stack(
          children: toLearn
              .map((document) {
            return VocabCard(vocab: russianToGerman,snap: document);
          }).toList());
    }
  }
}