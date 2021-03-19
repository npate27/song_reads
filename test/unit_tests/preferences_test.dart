import 'package:flutter_test/flutter_test.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/constants/defaults.dart';
import 'package:song_reads/utils/pref_loader.dart';

main() {
  //TODO adapt for Hive preferences
  setUp(() {
    Map<String,dynamic> values = { LiteralConstants.maxResultsPreferenceKey: maxResultsDefault };
    for (CommentSource source in CommentSource.values) {
      values[source.inString] = useSourceDefault;
    }
    SharedPreferences.setMockInitialValues(values);
  });

  group('maxResults', () {
    test('maxResults preference is default value if not set', () async {
      expect(await getMaxResultPreference(), maxResultsDefault);
    });

    test('maxResults value is different after being set', () async {
      setMaxResultPreference(10);
      await Future.delayed(Duration(seconds: 1));
      expect(await getMaxResultPreference(), 10);
    });
  });

  group('sourceToggles', () {
    test('maxResults preference is default value if not set', () async {
      for (CommentSource source in CommentSource.values) {
        print('Checking default for ${source.inString} toggle');
        expect(await getSourcePreference(source), useSourceDefault);
      }
    });

    test('maxResults preference is default value if not set', () async {
      for (CommentSource source in CommentSource.values) {
        print('Checking changed val for ${source.inString} toggle');
        setSourcePreference(source, !useSourceDefault);
        await Future.delayed(Duration(seconds: 1)); 
        expect(await getSourcePreference(source), !useSourceDefault);
      }
    });
  });

}