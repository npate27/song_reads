import 'package:flutter/material.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/section_header.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';

class SearchResultExpansionPanelList extends StatefulWidget {
  final List<Source> albumResults, songResults;
  const SearchResultExpansionPanelList({Key key, this.albumResults, this.songResults}) : super(key: key);

  @override
  _SearchResultExpansionPanelListState createState() => _SearchResultExpansionPanelListState();
}

class _SearchResultExpansionPanelListState extends State<SearchResultExpansionPanelList> {
  List<bool> _isOpen = [false, false];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          isExpanded: _isOpen[0],
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SectionHeader(sectionTitle: LiteralConstants.songCommentHeader);
          },
          body: ListView.builder(
           padding: EdgeInsets.only(bottom: 10.0), // Prevent clipped card shadow at bottom of list
           scrollDirection: Axis.vertical,
           shrinkWrap: true,
           // itemCount: widget.results.length,
           itemCount: 10,
           itemBuilder: (BuildContext context, int index) {
             //TODO: temporary to avoid hitting api limits, remove
             // return CommentSourceResultCardItem(sourceData: widget.results[index]);
             return CommentSourceResultCardItem(sourceData: GeniusSong(
                 id: "test", title: "test", likes: 42069, numComments: 69));
           })
        ),
        ExpansionPanel(
          isExpanded: _isOpen[1],
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SectionHeader(sectionTitle: LiteralConstants.albumCommentHeader);
          },
          body: ListView.builder(
            padding: EdgeInsets.only(bottom: 10.0), // Prevent clipped card shadow at bottom of list
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // itemCount: widget.results.length,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              //TODO: temporary to avoid hitting api limits, remove
              // return CommentSourceResultCardItem(sourceData: widget.results[index]);
              return CommentSourceResultCardItem(sourceData: GeniusSong(
                  id: "test", title: "test", likes: 42069, numComments: 69));
            })
        )
      ],
      expansionCallback: (i, isOpen) =>
        setState(() =>
          _isOpen[i] = !isOpen,
        )
    );
  }
}
