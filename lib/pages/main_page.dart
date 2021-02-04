import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/now_playing_card.dart';
import 'package:song_reads/components/section_header.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/models.dart';


class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        LiteralConstants.appName,
                        style: TextStyle (fontSize: 30.0, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(Icons.settings, size: 30,),
                        onPressed: () { Navigator.pushNamed(context, RouterConstants.preferencesRoute); },
                    ),
                  ),
                ],
              ),
              NowPlayingCard(),
              SectionHeader(sectionTitle: LiteralConstants.songCommentHeader,),
              Expanded(child: Container(child: songSourceBlocBuilder())),
              SectionHeader(sectionTitle: LiteralConstants.albumCommentHeader,),
              // CommentSourceResult(sourceType: CommentSource.genius, sourceData: null),
            ],
          ),
        ),
      ),
    );
  }
}

//Generate ListView of song sources for comments
BlocBuilder<SearchSourceBloc, SearchState> songSourceBlocBuilder() {
  return BlocBuilder<SearchSourceBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchEmpty) {
          //TODO: get the query dynamically via OS-specific APIs, or allow manual search
          BlocProvider.of<SearchSourceBloc>(context).add(FetchSources(title: "Humble", artist: "Kendrick Lamar"));
        }
        if (state is SearchError) {
          return Center(
            child: Text('Failed to fetch source results'),
          );
        }
        if (state is SearchLoaded) {
          List<Source> results = state.results;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                return CommentSourceResult(sourceData: results[index]);
              }
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
  );
}