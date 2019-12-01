import 'package:flutter/material.dart';

import 'package:jeka/state_widget.dart';
import 'package:jeka/model/state.dart';

import 'package:jeka/ui/screens/login.dart';
import 'package:jeka/ui/widgets/settings_button.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  StateModel appState;
  String _language = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

  Widget _buildContent() {
    if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
    } else {
      setState(() {
        _language = appState.currentUser.language;
      });
      return _settingContent();
    }
  }

  Widget _settingContent() {
    return Scaffold (
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SettingsButton(
            Icons.exit_to_app,
            "Log out",
            appState.user.displayName,
                () async {
              await StateWidget.of(context).signOutOfGoogle();
            },
          ),
          Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Text("Primary language:"),
                  new Radio(
                      value: "German",
                      groupValue: _language,
                      onChanged: (String value) {
                        setState(() {
                          _language = value;
                          appState.currentUser.language = value;
                        });
                      }
                  ),
                  new Text(
                    'German',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(
                      value: "Russian",
                      groupValue: _language,
                      onChanged: (String value) {
                        setState(() {
                          _language = value;
                          appState.currentUser.language = value;
                        });
                      }
                  ),
                  new Text(
                    'Russian',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
          )

        ],
      ),
    );
  }
}