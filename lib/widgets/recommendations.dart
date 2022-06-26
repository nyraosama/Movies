import 'package:flutter/material.dart';
import 'package:movie_swira/bloc/movies_recommended_bloc.dart';
import 'package:movie_swira/model/movie_response.dart';

import 'buildErrorWidget.dart';
import 'buildLoadingWidget.dart';
import 'buildRecommendWidget.dart';

class Recommendations extends StatefulWidget {
  int movieID;

    Recommendations({Key key,this.movieID }) : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesRecommendedBloc.getMoviesRecommended(widget.movieID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesRecommendedBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return BuildRecommend(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error);
        } else {
          buildLoadingWidget();
        }
        return SizedBox();
      },
    );
  }
}
