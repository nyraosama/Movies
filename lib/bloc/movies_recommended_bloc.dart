import 'package:movie_swira/model/movie_response.dart';
import 'package:movie_swira/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesRecommendedListBloc {

  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMoviesRecommended(int movieID) async {
    MovieResponse response = await _repository.getMoviesRecommended(movieID);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final moviesRecommendedBloc = MoviesRecommendedListBloc();

