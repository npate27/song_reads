
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/clients/http_client_singleton.dart';
import 'package:song_reads/models/song_info.dart';
import 'package:song_reads/repositories/spotify_repository.dart';
import 'package:song_reads/utils/token_store.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;


class SongSearchSheet extends StatefulWidget {
  @override
  _SongSearchSheetState createState() => _SongSearchSheetState();
}

class _SongSearchSheetState extends State<SongSearchSheet> {
  final SearchBarController<SongInfo> _searchBarController = SearchBarController();
  @override
  Widget build(BuildContext context) {
    return Column(
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
              Image.asset('assets/images/logos/spotify-logo.png', height: 30),
              SizedBox(width: 5),
              Text("SEARCH ON SPOTIFY", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Color(0xFF1DB954)))
            ],
          ),
        ),
        Expanded(child: _searchBar(context, _searchBarController))
      ],
    );
  }
}


SearchBar _searchBar(BuildContext context, SearchBarController searchBarController) {
  return SearchBar<SongInfo>(
    searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
    headerPadding: EdgeInsets.symmetric(horizontal: 10),
    listPadding: EdgeInsets.symmetric(horizontal: 10),
    onSearch: _getSpotifyResults,
    searchBarController: searchBarController,
    placeHolder: Text("No results yet"),
    cancellationWidget: Icon(Icons.cancel, size: 35,),
    emptyWidget: Text("empty"),
    onCancelled: () {
      print("Cancelled triggered");
    },
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
  TokenStore tokenStore = await TokenStore.instance;
  List<SongInfo> searchResults =  await repository.getSongSearchResults(text, tokenStore.getValue(LiteralConstants.spotifyAccessTokenKey));
  return searchResults;
}