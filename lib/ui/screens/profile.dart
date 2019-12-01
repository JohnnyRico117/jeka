import 'package:flutter/material.dart';

import 'package:jeka/model/state.dart';
import 'package:jeka/state_widget.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  StateModel appState;

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.user.displayName),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildAvatar(),
            _buildUserInfo(),
            //_buildCards("Projects", Icons.folder, '/projects'),
          ],
        ),
      )
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: CircleAvatar(
        backgroundImage: new NetworkImage(appState.user.photoUrl),
        radius: 50.0,
      ),
    );
  }

  Widget _buildUserInfo() {
    return new Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Text(
                            appState.user.displayName.split(" ").first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                            )
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.yellow),
                          Container(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                appState.currentUser.points.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.people, color: Colors.blue),
                          Container(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                appState.currentUser.friends.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                )
            )
          ],
        )
    );
  }

  Widget _buildCards(String title, IconData icon, String route) {
    Card _buildCard() {
      return Card(
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 0.1),
              leading: Icon(icon, color: Colors.white),
              title: Text(
                title,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: _buildCard()
//      child: Padding(
//        padding: EdgeInsets.symmetric(horizontal: 3.0),
//        child: Card(
//          child: Column(
//            mainAxisSize: MainAxisSize.min,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              _buildCard(),
//            ],
//          ),
//        ),
//      ),
    );
  }

}