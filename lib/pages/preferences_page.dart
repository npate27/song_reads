import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:song_reads/components/preferences_spotify_login_section.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/utils/preferences_store.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;

class PreferencesPage extends StatefulWidget {
  PreferencesPage({Key key}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SettingsSection(
            title: 'Results',
            tiles: [
              SettingsTile(
                title: 'Max Results',
                subtitle: 'Getting the top 5 results per source ', //TODO: Make dynamic from shared_preferences
                leading: Icon(Icons.list),
                onPressed: (BuildContext context) {
                  //TODO: open dialog to let user select this (1,2,3...max?)
                  PreferencesStore.instance.setMaxResultsPref(5);
                  print("MAX PREF: " + (PreferencesStore.instance.maxResultsPref()).toString());
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Sources',
            subtitle: Text(
                'Determines which sources to include in results'),
            tiles: generateSourceSettingsToggles()
          ),
          SettingsSection(
              title: 'Misc',
              tiles: [
                SettingsTile(
                  title: 'App Info',
                  subtitle: 'Version, Licences and Legal',
                  leading: Icon(Icons.info_outline_rounded),
                  onPressed: (BuildContext context) {showAboutDialog(context: context);},
                )
              ]
          ),
          SpotifyLoginPreferenceSection()
        ],
      ),
    );
  }

  List<SettingsTile> generateSourceSettingsToggles() {
    List<SettingsTile> sourceToggles = [];
    PreferencesStore preferences = PreferencesStore.instance;
    for (CommentSource source in CommentSource.values) {
      bool switchValue = preferences.sourcePref(source);
      sourceToggles.add(SettingsTile.switchTile(
        title: source.capitalizedSource,
        leading: Icon(Icons.web),
        switchValue: switchValue,
        onToggle: (bool value) {
          preferences.setSourcePref(source, value);
          //TODO: Make a separate widget, this renders the entire pref page, should isolate to own widget
          // without this, the toggle doesn't immediately update
          setState(() {});
        },
      ));
    }
    return sourceToggles;
  }
}

