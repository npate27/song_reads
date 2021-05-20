import 'dart:async';
import 'dart:math';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/bloc/color_reveal/color_reveal_bloc.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/custom_loading_indicator.dart';
import 'package:song_reads/components/now_playing_card.dart';
import 'package:song_reads/components/search_result_expansion_panel_list.dart';
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

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
          children: [
            colorRevealBuilder(),
            SafeArea(
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
                    songSearchBlocBuilder(),
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }

  //Updates background circular reveal animation color when
  BlocBuilder<ColorRevealBloc, ColorRevealState> colorRevealBuilder() {
    Color previousColor;
    Color revealColor;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return BlocBuilder<ColorRevealBloc, ColorRevealState>(
      builder: (context, state) {
        animationController.reset();
        if (state is InitialColorRevealState) {
          previousColor = Colors.grey;
          revealColor = Colors.grey;
        }
        if (state is ChangeColorRevealState){
          previousColor = revealColor;
          revealColor = state.color;
        }

        Future.delayed(const Duration(milliseconds: 100), () {
          animationController.forward();
        });

        return Stack(
          children: [
            Container(color: previousColor),
            CircularRevealAnimation(
              child: SizedBox.expand(child: Container(color: revealColor)),
              //TODO: Do this better. Currently really rough calculations based on padding/img values
              // maybe use GlobalKey on image to get position?
              centerOffset: Offset(50, mediaQuery.padding.top + 100),
              animation: animation,
              minRadius: 0,
              maxRadius: sqrt( pow(mediaQuery.size.width-50, 2)+ pow(mediaQuery.size.height-mediaQuery.padding.top-100, 2)),
            )
          ],
        );

      }
    );
  }

  //Update NowPlayingCard when new song is selected in modal or currently playing song if any on spotify if user is logged in
  BlocBuilder<SongBloc, SongState> songBlocBuilder() {
    //Empty timer init since it cant be null
    Timer delayNextQueryTimer = Timer(Duration(seconds: 0), () => {});
    SongInfo curSongInfo;
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
            //Cancel timer since we revert to manual selection
            if(delayNextQueryMs == null) {
              delayNextQueryTimer.cancel();
            }
            //Wait for song to end to requery if needed
            //extra padding for delays in network request in case song result came up the same still
            else {
              delayNextQueryTimer = Timer(Duration(milliseconds: delayNextQueryMs + 1500), () {
                //TODO handle ads
                BlocProvider.of<SongBloc>(context).add(FindCurrentlyPlayingSpotifySong());
              });
            }

            //Only requery sources if song changes
            //TODO: this stops the timer when the next song eventually comes
            //on if the current song is started over, fix
            if (songInfo != curSongInfo) {
              BlocProvider.of<SearchSourceBloc>(context).add(FetchSources(songInfo: songInfo, currentAlbum: curSongInfo?.album));
              curSongInfo = songInfo;
            }
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
                child: CustomLoadingIndicator()
            );
          }
          if (state is SearchSourceLoaded) {
            List<Source> songResults = state.songResults;
            List<Source> albumResults = state.albumResults;

            return Expanded(
              child: SingleChildScrollView(
                child: SearchResultExpansionPanelList(songResults: songResults, albumResults: albumResults),
              ),
            );
          }
          return Center(
              child: Text("No results yet")
          );
        }
    );
  }
}