import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';
import 'package:song_reads/models/song_info.dart';

class SongSearchSheet extends StatefulWidget {
  @override
  _SongSearchSheetState createState() => _SongSearchSheetState();
}

class _SongSearchSheetState extends State<SongSearchSheet> {
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
      ],
    );
  }
}


SearchBar _searchBar(BuildContext context) {
  return SearchBar<SongInfo>(
    searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
    headerPadding: EdgeInsets.symmetric(horizontal: 10),
    listPadding: EdgeInsets.symmetric(horizontal: 10),
    onSearch: _getALlPosts,
    searchBarController: _searchBarController,
    placeHolder: Text("placeholder"),
    cancellationWidget: Text("Cancel"),
    emptyWidget: Text("empty"),
    indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
    onCancelled: () {
      print("Cancelled triggered");
    },
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    crossAxisCount: 2,
    onItemFound: (SongInfo searchResult, int index) {
      return Container(
        child: ListTile(
          title: Text(searchResult.title),
          isThreeLine: true,
          subtitle: Text(searchResult.artist),
          onTap: () {
            print("Tapped result");
          },
        ),
      );
    },
  );
}