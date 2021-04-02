import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/now_playing_card.dart';
import 'package:song_reads/components/section_header.dart';
import 'package:song_reads/components/song_search_sheet.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/utils/token_store.dart';

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
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    // initUniLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            showModalBottomSheet(
              isScrollControlled: false,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              backgroundColor: Colors.white,
              context: context,
              builder: (context) => SongSearchSheet()
            );
        },
        child: Icon(Icons.search),
        backgroundColor: Colors.red,
      ),
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
              songBlocBuilder(),
              SectionHeader(sectionTitle: LiteralConstants.songCommentHeader, headerIndex: 0, collapseHeaderCallBack: collapseHeaderCallBack,),
              Visibility(visible: isSectionExpanded[0], child: Container(child: Expanded(child: songSearchBlocBuilder()))),
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
BlocBuilder<SearchSourceBloc, SearchState> songSearchBlocBuilder() {
  return BlocBuilder<SearchSourceBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchEmpty) {
          //TODO: get the query dynamically via OS-specific APIs
          return Center(
            child: Text("No results yet"),
          );
        }
        if (state is SearchError) {
          return Center(
            child: Text('Failed to fetch source results'),
          );
        }
        if (state is SearchLoading) {
          return Center(
            child: CircularProgressIndicator()
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
          child: Text("No results yet")
        );
      }
  );
}

//Update NowPlayingCard when new song is selected in modal or currently playing song if any on spotify if user is logged in
BlocBuilder<SongBloc, SongState> songBlocBuilder() {
  Timer delayNextQueryTimer;
  return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongDiscovery) {
          if(state.isLoggedIn) {
            BlocProvider.of<SongBloc>(context).add(FindCurrentlyPlayingSpotifySong());
          }
          return Center(
            child: Text("No song detected or selected, search for one")
        );
        }
        if (state is SongLoaded) {
          SongInfo songInfo = state.songInfo;
          int delayNextQueryMs = state.delayNextQueryMs;
          delayNextQueryTimer = Timer(Duration(milliseconds: delayNextQueryMs), () {
            //TODO handle ads
            BlocProvider.of<SongBloc>(context).add(FindCurrentlyPlayingSpotifySong());
          });
          //Cancel timer since we revert to manual selection
          if(delayNextQueryMs == null) {
            delayNextQueryTimer.cancel();
          }
          BlocProvider.of<SearchSourceBloc>(context).add(FetchSources(songInfo: songInfo));
          return NowPlayingCard(songInfo: songInfo);
        }
        if (state is SongInit) {
          BlocProvider.of<SongBloc>(context).add(SongLoginCheck());
        }
        return Center(
            child: Text("No song detected or selected, search for one")
        );
      }
  );
}