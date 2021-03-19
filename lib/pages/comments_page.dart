import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/clients/http_client_singleton.dart';
import 'package:song_reads/components/comment_info_view.dart';
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
  SearchSourceBloc bloc = SearchSourceBloc(ytRepository: YouTubeRepository(apiClient: YouTubeApiClient(httpClient: AppHttpClient().client)), redditRepository: RedditRepository(apiClient: RedditApiClient(httpClient: AppHttpClient().client)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Expanded(child: songSourceCommentsBlocBuilder(bloc, widget.sourceData.id, widget.sourceData.commentSource)))
          ],
        ),
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
BlocBuilder<SearchSourceBloc, SearchState> songSourceCommentsBlocBuilder(SearchSourceBloc bloc, String sourceId, CommentSource source) {
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
          child: CircularProgressIndicator(),
        );
      }
  );
}