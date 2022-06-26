import 'package:movie_swira/model/movie.dart';
import 'package:movie_swira/model/movie_response.dart';
import 'package:movie_swira/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

import 'now_playing_bloc.dart';

class DetailsMovieBlock {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<Movie> _subject =
  BehaviorSubject<Movie>();

  getMovie(int movieID) async {
    Movie response = await _repository.getDetailsMovie(movieID);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Movie> get subject => _subject;
}

final detailsMovieBloc = DetailsMovieBlock();
