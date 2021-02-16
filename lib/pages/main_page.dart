import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/now_playing_card.dart';
import 'package:song_reads/components/section_header.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //TODO: maybe make this an enum so can be expanded upon later
  List<bool> isSectionExpanded = [true, true]; //[Song section, Album section]

  //TODO: manage this with bloc? or too complex? Just dont want to redraw entire widget tree because of this...
  void collapseHeaderCallBack(int index) {
    setState(() {
      isSectionExpanded[index] = !isSectionExpanded[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
              SectionHeader(sectionTitle: LiteralConstants.songCommentHeader, headerIndex: 0, collapseHeaderCallBack: collapseHeaderCallBack,),
              Visibility(visible: isSectionExpanded[0], child: Container(child: Expanded(child: songSourceBlocBuilder()))),
              SectionHeader(sectionTitle: LiteralConstants.albumCommentHeader, headerIndex: 1, collapseHeaderCallBack: collapseHeaderCallBack,),
              // Visibility(visible: isSectionExpanded[1], child: Container(child: Expanded(child: songSourceBlocBuilder()))),
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
        if (state is SearchSourceLoaded) {
          List<Source> results = state.results;
          return ListView.builder(
              padding: EdgeInsets.only(bottom: 10.0), // Prevent clipped card shadow at bottom of list
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                return CommentSourceResultCardItem(sourceData: results[index]);
              }
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
  );
}