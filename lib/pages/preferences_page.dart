import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/utils/preferences.dart';
import 'package:song_reads/utils/auth_utils.dart';
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
          FutureBuilder<List<SettingsTile>>(
            future: generateSourceSettingsToggles(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                  return Flexible(
                    child: SettingsList(
                      sections: [
                        SettingsSection(
                          title: 'Results',
                          tiles: [
                            SettingsTile(
                              title: 'Max Results',
                              subtitle: 'Getting the top 5 results per source ', //TODO: Make dynamic from shared_preferences
                              leading: Icon(Icons.list),
                              onPressed: (BuildContext context) async {
                                //TODO: open dialog to let user select this (1,2,3...max?)
                                Preferences preferences = await Preferences.instance;
                                preferences.setMaxResultsPref(5);
                                print("MAX PREF: " + (preferences.maxResultsPref()).toString());
                              },
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: 'Sources',
                          subtitle: Text(
                              'Determines which sources to include in results'),
                          tiles: snapshot.data,
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
                        SettingsSection(
                            title: 'Login',
                            tiles: [
                              SettingsTile(
                                title: 'Login With Spotify',
                                subtitle: 'Lets the SongReads use your currently playing song to find comments',
                                leading: Icon(Icons.login),
                                onPressed: (BuildContext context) async{
                                  //TODO: process if cancelled/failed
                                  logInAuthPKCE(LiteralConstants.spotifyClientKey, LiteralConstants.redirectUrl, SpotifyApiClient.authConfig, SpotifyApiClient.userListeningScopes);
                                },
                              )
                            ]
                        )
                      ],
                    ),
                  );
              }
              return CircularProgressIndicator();
            }
          ),
        ],
      ),
    );
  }

  Future<List<SettingsTile>> generateSourceSettingsToggles() async {
    List<SettingsTile> sourceToggles = [];
    Preferences preferences = await Preferences.instance;
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

