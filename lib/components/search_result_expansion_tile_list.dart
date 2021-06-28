import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/section_header.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/utils/color_utils.dart';

class SearchResultExpansionPanelList extends StatefulWidget {
  final List<Source> songResults, albumResults;
  const SearchResultExpansionPanelList({Key key, this.songResults, this.albumResults}) : super(key: key);

  @override
  _SearchResultExpansionPanelListState createState() => _SearchResultExpansionPanelListState();
}

class _SearchResultExpansionPanelListState extends State<SearchResultExpansionPanelList> {
  //TODO: make this default be better, depends on default background color, currently grey.
  Color contrastColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColorRevealBloc, ColorRevealState>(
        listener: (BuildContext context, ColorRevealState state) {
          if (state is ChangeColorRevealState) {
            setState(() {
              contrastColor = lightAdjustedComplimentColor(state.colorPalettes.dominantColor.color);
            });
          }
        },
        child: Theme(
          // Theme to remove divider line on exapnded tiles
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent, accentColor: contrastColor, unselectedWidgetColor: contrastColor),
          child: Column(
            children: [
              resultExpansionTile(LiteralConstants.songCommentHeader, widget.songResults, Icons.music_note),
              resultExpansionTile(LiteralConstants.albumCommentHeader, widget.albumResults, Icons.album)
            ],
          ),
        )
    );
  }

  ExpansionTile resultExpansionTile(String headerTitle, List<Source> results, IconData iconData) {
    return ExpansionTile(
        title: Row(
          children: [
            Icon(iconData, size: 30, color: contrastColor),
            SizedBox(width: 10),
            Text(
              headerTitle,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: contrastColor
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        children: [
          ListView.builder(
            padding: EdgeInsets.only(bottom: 10.0), // Prevent clipped card shadow at bottom of list
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            // itemCount: results.length,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              //TODO: temporary to avoid hitting api limits, remove
              // return CommentSourceResultCardItem(sourceData: results[index]);
              return CommentSourceResultCardItem(sourceData: GeniusSong(
                  id: "test", title: "test", likes: 42069, numComments: 69));
            })
        ]
    );
  }
}
