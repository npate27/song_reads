import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:song_reads/utils/pref_loader.dart';


class PreferencesPage extends StatefulWidget {
  PreferencesPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<PreferencesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: 'Sources',
                  subtitle: Text('Determines which sources to include in results'),
                  tiles: generateSettingsTiles(),
                ),
                SettingsSection(
                  title: 'Results',
                  tiles: [
                    SettingsTile(
                      title: 'Max Results',
                      subtitle: 'Getting the top 5 results per source ', //TODO: Make dynamic from shared_preferences
                      leading: Icon(Icons.list),
                      onPressed: (BuildContext context) async {
                        //TODO: open dialog to let user select this (1,2,3...max?)
                        setMaxResultPreference(5);
                        print("MAX PREF: " + (await getMaxResultPreference()).toString());
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<SettingsTile> generateSettingsTiles() {
    return [
      //TODO make this dynamic based on enum CommentSource
      // probably need to pass a function in onToggle to set proper prefs
      SettingsTile.switchTile(
        title: 'Youtube',
        leading: Icon(Icons.web),
        switchValue: false,
        onToggle: (bool value) {
        },
      ),
      SettingsTile.switchTile(
        title: 'Reddit',
        leading: Icon(Icons.web),
        switchValue: false,
        onToggle: (bool value) {},
      ),
      SettingsTile.switchTile(
        title: 'Genius',
        leading: Icon(Icons.web),
        switchValue: false,
        onToggle: (bool value) {},
      ),
    ];
  }
}

