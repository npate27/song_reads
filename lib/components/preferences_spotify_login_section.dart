import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/utils/auth_utils.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;

class SpotifyLoginPreferenceSection extends StatefulWidget {
  @override
  _SpotifyLoginPreferenceSectionState createState() => _SpotifyLoginPreferenceSectionState();
}

class _SpotifyLoginPreferenceSectionState extends State<SpotifyLoginPreferenceSection> {
  bool userLoggedIn;

  @override
  void initState() {
    userLoggedIn = isUserLoggedIn();
    super.initState();
  }

  updateUserLoginState(bool loginStatus) {
    if (mounted) {
      setState(() {
        userLoggedIn = loginStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
        title: 'Manage Spotify Login',
        tiles: [
          getSpotifyTile()
        ]
    );
  }

  getSpotifyTile() {
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
        onPressed: (BuildContext context) async{
          //TODO: process if cancelled/failed
          bool logInSuccessful = await logInSpotifyAuthPKCE(LiteralConstants.spotifyClientKey, LiteralConstants.redirectUrl, SpotifyApiClient.authConfig, SpotifyApiClient.userListeningScopes);
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
        },
      );
    }
  }
}
