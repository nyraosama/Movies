import 'package:movie_swira/model/movie.dart';
import 'package:movie_swira/utils/MovieDB.dart';
import 'package:rxdart/rxdart.dart';

import 'FavoritosBloc.dart';

class MovieControlBloc {

  final _flagFavoritos = BehaviorSubject<bool>();
  get getFavoritos => _flagFavoritos.stream;
  get setFavorito => _flagFavoritos.sink.add;

  Future<bool> fetchFavorito(Movie m) async {
    final db = MovieDB.getInstance();

    final b = await db.exists(m);

    setFavorito(b);

    return b;
  }

  Future<bool> favoritar(Movie m) async {
    final db = MovieDB.getInstance();

    final exists = await db.exists(m);

    try {
      if (exists) {
        await db.deleteMovie(m);

        setFavorito(false);

        return false;
      } else {
        await db.saveMovie(m);

        setFavorito(true);

        return true;
      }
    } finally {
     final favoritosBloc = FavoritesBloc();
      favoritosBloc.fetch();
    }
  }

  dispose() {
    _flagFavoritos.close();
  }
}
