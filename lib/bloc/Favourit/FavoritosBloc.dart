import 'package:movie_swira/model/movie.dart';
import 'package:movie_swira/utils/MovieDB.dart';
import 'package:movie_swira/utils/simple_bloc.dart';

class FavoritesBloc extends SimpleBloc<List<Movie>> {
  Future fetch({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        add(null);
      }

      final db = MovieDB.getInstance();
      final movies = await db.getMovies();

      add(movies);

      return movies;
    } catch (error, exception) {
      print("$error - $exception");

      addError("No Items in Film Favourite .");
    }
  }
}