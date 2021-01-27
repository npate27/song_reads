import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:song_reads/constants/enums.dart';
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
        children: [
          FutureBuilder<List<SettingsTile>>(
            future: generateSourceSettingsToggles(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<SettingsTile>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
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
                                setMaxResultPreference(5);
                                print("MAX PREF: " + (await getMaxResultPreference()).toString());
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

  Future<List<SettingsTile>> generateSourceSettingsToggles() async{
    List<SettingsTile> sourceToggles = [];
    for (CommentSource source in CommentSource.values) {
      bool switchValue = await getSourcePreference(source);
      sourceToggles.add(SettingsTile.switchTile(
        title: source.capitalizedSource,
        leading: Icon(Icons.web),
        switchValue: switchValue,
        onToggle: (bool value) {
          setSourcePreference(source, value);
          //TODO: Make a separate widget, this renders the entire pref page, should isolate to own widget
          // without this, the toggle doesn't immediately update
          setState(() {});
        },
      ));
    }
    return sourceToggles;
  }
}

