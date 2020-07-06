import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class VocabCard extends StatefulWidget {
  final DocumentSnapshot snap;
  final bool vocab;

  const VocabCard({Key key, this.snap, this.vocab}) : super(key: key);

  @override
  _VocabCardState createState() => _VocabCardState();
}

class _VocabCardState extends State<VocabCard> {
  bool clicked;

  @override
  void initState() {
    super.initState();
    clicked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              )),
          child: Center(
            child: widget.vocab ? Text(
              clicked ? widget.snap.data['german'] : widget.snap.data['russian'],
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ) : Text(
              clicked ? widget.snap.data['russian'] : widget.snap.data['german'],
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            clicked = !clicked;
          });
        },
      ),
    );
  }
}
