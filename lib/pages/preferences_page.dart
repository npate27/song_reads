import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:song_reads/clients/spotify_api_client.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/utils/auth_utils.dart';
import 'package:song_reads/utils/preferences_store.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/constants/routes.dart' as RouterConstants;

class PreferencesPage extends StatefulWidget {
  final String authCode;

  PreferencesPage({Key key, this.authCode}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool userLoggedIn;

  @override
  void initState() {
    super.initState();
    if(kIsWeb) {
      userLoggedIn = widget.authCode?.isNotEmpty ?? isUserLoggedIn();
      if (userLoggedIn) {
        //TODO make this show the username
        Fluttertoast.showToast(
            msg: 'Successfully logged in Spotify as user',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );
      }
    } else {
      userLoggedIn = isUserLoggedIn();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  updateUserLoginState(bool loginStatus) {
    setState(() {
      userLoggedIn = loginStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        shrinkWrap: true,
        sections: [
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
          SettingsSection(
              title: 'Manage Spotify Login',
              tiles: [
                getSpotifyTile()
              ]
          ),
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
          // without this, the toggle doesn't immediately update
          setState(() {});
        },
      ));
    }
    return sourceToggles;
  }
  SettingsTile getSpotifyTile() {
    if (userLoggedIn) {
      return SettingsTile(
        title: 'Log out of Spotify',
        subtitle: 'Removes SongReads\' ability to automatically detect currently playing song on Spotify',
        leading: Icon(Icons.login),
        onPressed: (BuildContext context) async{
          //TODO: process if failed for some reason
          bool logOutSuccessful = logOutSpotify();
          if (logOutSuccessful) {
            updateUserLoginState(false);
            Fluttertoast.showToast(
                msg: 'Successfully logged out of Spotify',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1
            );
          }
        },
      );
    }
    else {
      return SettingsTile(
        title: 'Log in to Spotify',
        subtitle: 'Lets the SongReads use your currently playing song to find comments',
        leading: Icon(Icons.login),
        onPressed: (BuildContext context) async {
          //TODO: process if cancelled/failed
          bool logInSuccessful;
          if (kIsWeb) {
            logInSpotifyAuthPKCE(LiteralConstants.spotifyClientKey, LiteralConstants.redirectUrl, SpotifyApiClient.authConfig, SpotifyApiClient.userListeningScopes);
          } else {
            logInSuccessful = await logInSpotifyAuthPKCE(LiteralConstants.spotifyClientKey, LiteralConstants.redirectUrl, SpotifyApiClient.authConfig, SpotifyApiClient.userListeningScopes);
            if (logInSuccessful) {
              updateUserLoginState(true);
              //TODO make this show the username
              Fluttertoast.showToast(
                  msg: 'Successfully logged in Spotify as user',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1
              );
            }
          }
        },
      );
    }
  }
}

