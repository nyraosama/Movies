import 'package:flutter/material.dart';
import 'package:movie_swira/bloc/Favourit/MovieFavouriteBloc.dart';
import 'package:movie_swira/bloc/now_playing_bloc.dart';
import 'package:movie_swira/model/movie.dart';
import 'package:movie_swira/model/movie_response.dart';
import 'package:movie_swira/screens/detailsmoviescreen.dart';
import 'package:movie_swira/utils/theme.dart' as Style;

import 'buildErrorWidget.dart';
import 'buildLoadingWidget.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState() {
    super.initState();
    nowPlayingBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return buildNowPlayingWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error);
        } else {
          buildLoadingWidget();
        }
        return SizedBox();
      },
    );
  }

  Widget buildNowPlayingWidget(MovieResponse data) {
    List<Movie> movies = data.movies;

    //Sort
    movies.sort((a, b) => a.title.toString().compareTo(b.title.toString()));

    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Movies"),
          ],
        ),
      );
    } else {
      return Container(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsMovieScreen(movies[index]),
                  ));
            },
            child: Stack(
              children: [
                Container(
                  height: 220.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://image.tmdb.org/t/p/original" +
                            movies[index].posterPath,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                FavouriteInList(
                  movie: movies[index],
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Style.Colors.mainColor.withOpacity(1.0),
                        Style.Colors.mainColor.withOpacity(0.0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [
                        0.0,
                        0.9,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movies[index].title,
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          movies[index].releaseDate,
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 310,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rate,
                          color: Colors.yellow,
                        ),
                        Text(
                          "${movies[index].voteAverage}",
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ));
    }
  }
}

class FavouriteInList extends StatefulWidget {
  Movie movie;

  FavouriteInList({Key key, this.movie}) : super(key: key);

  @override
  _FavouriteInListState createState() => _FavouriteInListState();
}

class _FavouriteInListState extends State<FavouriteInList> {
  final _bloc = MovieControlBloc();

  @override
  void initState() {
    super.initState();
    _bloc.fetchFavorito(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: StreamBuilder<bool>(
        initialData: false,
        stream: _bloc.getFavoritos,
        builder: (context, snapshot) {
          print('Builder  ${snapshot.data}');

          return Icon(
            Icons.favorite,
            size: 34,
            color: snapshot.data ? Colors.red : Colors.white,
          );
        },
      ),
      onPressed: () {
        _onClickFavoritar(widget.movie);
      },
    );
  }

  Future _onClickFavoritar(Movie movie) async {
    _bloc.favoritar(movie);
  }
}
