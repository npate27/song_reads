import 'package:flutter/material.dart';
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

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //TODO: make this dynamic based on manual search or detection
  SongInfo songInfo = SongInfo(title: "10%", artist: "KAYTRANADA, Kali Uchis", album: "BUBBA", artworkImage: "https://i.scdn.co/image/ab67616d0000b2739b6375bad39943011986c247");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
              NowPlayingCard(songInfo: songInfo),
              SectionHeader(sectionTitle: LiteralConstants.songCommentHeader, headerIndex: 0, collapseHeaderCallBack: collapseHeaderCallBack,),
              Visibility(visible: isSectionExpanded[0], child: Container(child: Expanded(child: songSourceBlocBuilder(songInfo)))),
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
BlocBuilder<SearchSourceBloc, SearchState> songSourceBlocBuilder(SongInfo songInfo) {
  return BlocBuilder<SearchSourceBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchEmpty) {
          //TODO: get the query dynamically via OS-specific APIs, or allow manual search
          BlocProvider.of<SearchSourceBloc>(context).add(FetchSources(title: songInfo.title, artist: songInfo.artist));
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