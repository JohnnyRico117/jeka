import 'package:flutter/material.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jeka/state_widget.dart';

import 'package:jeka/model/state.dart';

import 'package:jeka/ui/screens/vocabulary.dart';
import 'package:jeka/ui/screens/login.dart';
import 'package:jeka/ui/screens/sentences.dart';
import 'package:jeka/ui/screens/friend_list.dart';
import 'package:jeka/ui/screens/vocab_cards.dart';
//import 'package:sabawa/ui/screens/phases.dart';
import 'package:jeka/ui/widgets/loading_indicator.dart';

class JekaTabController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new JekaTabControllerState();
}

class JekaTabControllerState extends State<JekaTabController> {

  StateModel appState;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
//    Progress(),
//    ToDoList(),

//    Phases(),
    VocabCards(),
    VocabList(),
    SentenceList(),
    FriendList(),
    Center(child: Icon(Icons.chat)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return LoadingIndicator();
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
////    } else if (appState.newuser == true) {
////      return new ProfileSetUp();
    } else {
      return _buildBottomTabs();
    }
  }

  Widget _buildBottomTabs() {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile'),
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: appState.user.photoUrl == null ? null : new NetworkImage(appState.user.photoUrl),
            ),
          )
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings), 
              onPressed: () => Navigator.pushNamed(context, '/settings')
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.list),
            title: Text('Vocabs'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.storage),
            title: Text('Sentences'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.people),
            title: Text('Friends'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black26,
        onTap: _onItemTapped,
      ),
    );
  }
}