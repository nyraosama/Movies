import 'package:flutter/material.dart';
import 'package:movie_swira/bloc/Favourit/FavoritosBloc.dart';
import 'package:movie_swira/utils/theme.dart' as Style;
import 'package:movie_swira/model/movie.dart';
import 'package:movie_swira/widgets/buildErrorWidget.dart';
import 'detailsmoviescreen.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with AutomaticKeepAliveClientMixin<FavouriteScreen> {
  @override
  bool get wantKeepAlive => true;

  final bloc = FavoritesBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        title: Text(
          "Favourites",
        ),
        centerTitle: true,
        backgroundColor: Style.Colors.mainColor,
      ),
      body: StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Erro
            return Center(
              child: buildErrorWidget(snapshot.error),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Movie> movies = snapshot.data;
          print("Movies $movies");

          return movies.isEmpty
              ? buildErrorWidget("No Found in Favourite")
              : _griView(movies, context);
        },
      ),
    );
  }

  _griView(List<Movie> movies, context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _item(movies, index, context);
        },
      ),
    );
  }

  _item(List<Movie> movies, index, context) {

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsMovieScreen(movies[index]),
            ));
      },
      child: Container(
        height: 100,
         child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(

                margin: EdgeInsets.only(left: 5,right: 5),
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://image.tmdb.org/t/p/w200" +
                            movies[index].posterPath,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        movies[index].title,
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        child: Text(
                          "${movies[index].voteAverage.toString()} Ratings",
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.green,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                     ],
                ),
              ),

          ), );

  }

  //
  // void _onClickMovie(Movie m) {
  //   push(context, MoviePage(m));
  // }

  Future<void> _onRefresh() {
    return bloc.fetch();
  }

  Future<void> _onRefreshError() {
    return bloc.fetch(isRefresh: true);
  }
}
