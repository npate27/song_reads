import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/section_header.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';

class SearchResultExpansionPanelList extends StatefulWidget {
  final List<Source> songResults, albumResults;
  const SearchResultExpansionPanelList({Key key, this.songResults, this.albumResults}) : super(key: key);

  @override
  _SearchResultExpansionPanelListState createState() => _SearchResultExpansionPanelListState();
}

class _SearchResultExpansionPanelListState extends State<SearchResultExpansionPanelList> {
  //TODO: make this default be better, depends on default background color, currently grey.
  Color contrastColor = Colors.black;
  List<bool> _isOpen = [false, false]; //[song, album]

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isOpen[0] = widget.songResults.isNotEmpty;
        _isOpen[1] = widget.albumResults.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColorRevealBloc, ColorRevealState>(
        listener: (BuildContext context, ColorRevealState state) {
          if (state is ChangeColorRevealState) {
            setState(() {
              contrastColor = state.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
            });
          }
        },
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          elevation: 0,
          children: [
            resultExpansionPanel(LiteralConstants.songCommentHeader, widget.songResults, 0),
            resultExpansionPanel(LiteralConstants.albumCommentHeader, widget.albumResults, 1)
          ],
          expansionCallback: (i, isOpen) =>
            setState(() =>
              _isOpen[i] = !isOpen,
            )
        )
    );


  }

  ExpansionPanel resultExpansionPanel(String headerTitle, List<Source> results, int isExpandedIndex) {
    //TODO: Replicate ExpansionPanelClass so that trailing icon color can also change
    return ExpansionPanel(
        canTapOnHeader: true,
        backgroundColor: Colors.transparent,
        isExpanded: _isOpen[isExpandedIndex],
        headerBuilder: (BuildContext context, bool isExpanded) {
          return SectionHeader(sectionTitle: headerTitle, contrastColor: contrastColor);
        },
        body: ListView.builder(
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
    );
  }
}
