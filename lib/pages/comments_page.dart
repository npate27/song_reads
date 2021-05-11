import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/clients/http_client_singleton.dart';
import 'package:song_reads/components/comment_info_view.dart';
import 'package:song_reads/components/comment_source_info.dart';
import 'package:song_reads/components/custom_loading_indicator.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/models/source_model.dart';
import 'package:song_reads/repositories/repositories.dart';

class CommentsPage extends StatefulWidget {
  final Source sourceData;
  CommentsPage({Key key, this.sourceData}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  SearchSourceBloc bloc = SearchSourceBloc(
      ytRepository: YouTubeRepository(apiClient: YouTubeApiClient(httpClient: AppHttpClient().client)),
      redditRepository: RedditRepository(apiClient: RedditApiClient(httpClient: AppHttpClient().client)),
      geniusRepository: GeniusRepository(apiClient: GeniusApiClient(httpClient: AppHttpClient().client))
  );

  @override
  Widget build(BuildContext context) {
    Source sourceData = widget.sourceData;
    CommentSource commentSource = sourceData.commentSource;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            height: 100,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.25, 1],
                      colors: [commentSource.sourceImageBaseColor, commentSource.sourceImageBaseColor.withOpacity(0.35)],
                    )
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Image.asset(commentSource.sourceImagePath),
                                ),
                                //TODO: There's gotta be a better way of doing this surely
                                Flexible(child: Container(child: CommentSourceInfo(sourceData: sourceData,)))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,),
                        ),
                      )
                    ]
                ),
              ),
            ),
          ),
          Container(child: Expanded(child: songSearchCommentsBlocBuilder(bloc, widget.sourceData.id, widget.sourceData.commentSource)))
        ],
      ),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}


//Generate ListView of song sources for comments
BlocBuilder<SearchSourceBloc, SearchState> songSearchCommentsBlocBuilder(SearchSourceBloc bloc, String sourceId, CommentSource source) {
  return BlocBuilder<SearchSourceBloc, SearchState>(
      cubit: bloc,
      builder: (context, state) {
        if (state is SearchEmpty) {
          bloc.add(FetchComments(id: sourceId, source: source));
        }
        //TODO: reddit entries are hitting this, fix
        if (state is SearchError) {
          return Center(
            child: Text('Failed to fetch comments'),
          );
        }
        if (state is SearchCommentsLoaded) {
          List<CommentInfo> results = state.results;
          return ListView.builder(
              padding: EdgeInsets.only(bottom: 10.0), // Prevent clipped card shadow at bottom of list
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                return CommentInfoView(commentInfo: results[index]);
              }
          );
        }
        return Center(
          child: CustomLoadingIndicator(),
        );
      }
  );
}