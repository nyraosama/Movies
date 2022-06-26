import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:movie_swira/bloc/Favourit/MovieFavouriteBloc.dart';
import 'package:movie_swira/bloc/details_movie_block.dart';

import 'package:movie_swira/model/ResponseRate.dart';
import 'package:movie_swira/model/movie.dart';
import 'package:movie_swira/repository/respository.dart';
import 'package:movie_swira/utils/theme.dart' as Style;
import 'package:movie_swira/widgets/buildErrorWidget.dart';
import 'package:movie_swira/widgets/buildLoadingWidget.dart';
import 'package:movie_swira/widgets/poster.dart';
import 'package:movie_swira/widgets/rating_information.dart';
import 'package:movie_swira/widgets/recommendations.dart';

import 'FavouriteScreen.dart';

class DetailsMovieScreen extends StatefulWidget {
  Movie movie;

  DetailsMovieScreen(this.movie);

  @override
  _DetailsMovieScreenState createState() => _DetailsMovieScreenState();
}

class _DetailsMovieScreenState extends State<DetailsMovieScreen> {
  Movie get movie => widget.movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
          backgroundColor: Style.Colors.mainColor,
          centerTitle: true,
          title: Text(
            "${widget.movie.title}",
            style: TextStyle(color: Colors.white),
          ),
        actions: [
          Row(
            children: [
              TextButton(child: Text("My Favorites"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen(),));


                },),

            ],
          ),
        ],),
      body: DetailsBody(
        movie: widget.movie,
      ),
    );
  }
}

class DetailsBody extends StatefulWidget {
  const DetailsBody({Key key, this.movie}) : super(key: key);
  final Movie movie;

  @override
  _DetailsBodyState createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<DetailsBody> {
  final _bloc = MovieControlBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchFavorito(widget.movie);
    detailsMovieBloc.getMovie(widget.movie.id);
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Movie>(
      stream: detailsMovieBloc.subject.stream,
      builder: (context, AsyncSnapshot<Movie> snapshot) {
        print("snapshot  ${snapshot.data}");
        if (snapshot.hasData) {
          return buildDetailsWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error);
        } else {
          buildLoadingWidget();
        }
        return SizedBox();
      },
    );
  }

  Widget buildDetailsWidget(movie) {
    var movieInformation = Padding(
      padding: EdgeInsets.all(8),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Text(
            movie.title,
            style: TextStyle(
              height: 1.5,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          RatingInformation(movie),
          SizedBox(
            height: 10,
          ),
          Text(
            movie.overview,
            style: TextStyle(
              height: 1.5,
              color: Colors.white70,
              fontWeight: FontWeight.w900,
              fontSize: 12.0,
            ),
          ),
          SizedBox(height: 12.0),
          //Check If genres Null Show SizeBoc if not show list
          movie.genres != null
              ? SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: movie.genres.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 2),
                        margin: EdgeInsets.only(bottom: 2),
                        child: Text(
                          movie.genres[index].name + "  ",
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(
                  height: 1,
                ),

          Align(
            alignment: Alignment.center,
            child: RatingBar.builder(
              initialRating: movie.voteAverage,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                //Request Rate When change in value rating
                postRate(movie.id, rating);
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Recommendations(
            movieID: movie.id,
          )
        ],
      ),
    );

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
        child: Column(
          children: [
            Stack(
              children: [
                Poster(movie.posterPath),
                IconButton(
                  icon: StreamBuilder<bool>(
                    initialData: false,
                    stream: _bloc.getFavoritos,
                    builder: (context, snapshot) {
                      return Icon(
                        Icons.favorite,
                        size: 34,
                        color: snapshot.data ? Colors.red : Colors.white,
                      );
                    },
                  ),
                  onPressed: () {
                    _onClickFavoritar();
                  },
                )
              ],
            ),
            movieInformation,
            Padding(
              padding: const EdgeInsets.all(20.0),
              // child: Storyline(movie.storyline),
            ),
            //  PhotoScroller(movie.photoUrls),
            SizedBox(height: 20.0),
            // ActorScroller(movie.),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Future _onClickFavoritar() async {
    _bloc.favoritar(widget.movie);
  }

  Future<ResponseRate> postRate(int idMovie, double rate) async {
    Dio dio = Dio();
    final String apiKey = "1e8761464a3c37188f6afb11cb5344a4";
    var guest_session_id = "4ec37db39d6108ac0b8e0bcb9aca33ec";
    var params = {
      "value": rate,
    };
    try {
      Response response = await dio.post(
        "${MovieRepository.movieUrl}$idMovie/rating?api_key=$apiKey&guest_session_id=$guest_session_id",
        queryParameters: params,
      );
      if (response.statusCode == 201) {
        var responserate = ResponseRate.fromJson(response.data);
        final snackBar = SnackBar(content: Text("We have successfully rated"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return ResponseRate.fromJson(response.data);
    } catch (error, stacktrace) {
      print("exception occured: $error stackTrace: $stacktrace");
      return ResponseRate.fromJson(error);
    }
  }
}
