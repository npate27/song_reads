
import 'dart:math';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/clients/http_client_singleton.dart';
import 'package:song_reads/models/song_info.dart';
import 'package:song_reads/repositories/spotify_repository.dart';
import 'package:song_reads/utils/color_utils.dart';
import 'package:song_reads/utils/token_store.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;


class SongSearchSheet extends StatefulWidget {
  @override
  _SongSearchSheetState createState() => _SongSearchSheetState();
}

class _SongSearchSheetState extends State<SongSearchSheet> with SingleTickerProviderStateMixin{
  final SearchBarController<SongInfo> _searchBarController = SearchBarController();
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        colorRevealBuilder(),
        Column(
        children: [
          Padding(
            padding:EdgeInsets.only(top: 10.0),
            child:Container(
                height:5.0,
                width:50.0,
                decoration: BoxDecoration(
                    color:Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Image.asset('assets/images/logos/spotify-logo.png', height: 30),
                        SizedBox(width: 5),
                        Text("SEARCH ON SPOTIFY", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Color(0xFF1DB954)))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: _searchBar(context, _searchBarController))
        ],
      ),
      ]
    );
  }

  BlocBuilder<ColorRevealBloc, ColorRevealState> colorRevealBuilder() {
    Color previousColor;
    Color revealColor;
    return BlocBuilder<ColorRevealBloc, ColorRevealState>(
        builder: (context, state) {
          if (state is InitialColorRevealState) {
            previousColor = Colors.transparent;
            revealColor = Colors.transparent;
          }
          if (state is ChangeColorRevealState) {
            if (previousColor != revealColor) {
              animationController.reset();
            }
            previousColor = revealColor;
            revealColor = lightAdjustedComplimentColor(state.colorPalettes.dominantColor.color);
          }
          Future.delayed(const Duration(milliseconds: 100), () {
            animationController.forward();
          });

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Container(decoration: BoxDecoration(
                      color: previousColor,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  )),
                  CircularRevealAnimation(
                    child: SizedBox.expand(
                        child: Container(decoration: BoxDecoration(
                            color: revealColor,
                            borderRadius: BorderRadius.all(Radius.circular(
                                15.0))
                        ))),
                    //TODO: Do this better. Currently really rough calculations based on padding/img values
                    centerOffset: Offset(
                        constraints.maxWidth, constraints.maxHeight),
                    animation: animation,
                    minRadius: 100,
                    maxRadius: sqrt(pow(constraints.maxWidth, 2) +
                        pow(constraints.maxHeight, 2)) + 500,
                  )
                ],
              );
            },
          );
        }
    );
  }
}


SearchBar _searchBar(BuildContext context, SearchBarController searchBarController) {
  return SearchBar<SongInfo>(
    searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
    searchBarStyle: SearchBarStyle(backgroundColor: Colors.white),
    headerPadding: EdgeInsets.symmetric(horizontal: 10),
    listPadding: EdgeInsets.symmetric(horizontal: 10),
    onSearch: _getSpotifyResults,
    searchBarController: searchBarController,
    hintText: 'Song, Artist, Album',
    cancellationWidget: Icon(Icons.cancel, size: 35,),
    emptyWidget: Center(child: Text('No results found')),
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    crossAxisCount: 1,
    onItemFound: (SongInfo searchResult, int index) {
      return Container(
          child: ListTile(
            title: Text(searchResult.title),
            subtitle: Text(searchResult.artist),
            leading: Image.network(searchResult.artworkImage, height: 100),
            onTap: () {
              BlocProvider.of<SongBloc>(context).add(UpdateSong(songInfo: searchResult));
              Navigator.of(context).pop();
            },
            )
      );
    },
  );
}

Future<List<SongInfo>> _getSpotifyResults(String text) async {
  SpotifyRepository repository = SpotifyRepository(apiClient: SpotifyApiClient(httpClient: AppHttpClient().client));
  List<SongInfo> searchResults =  await repository.getSongSearchResults(text, TokenStore.instance.getValue(LiteralConstants.spotifyAccessTokenKey));
  return searchResults;
}