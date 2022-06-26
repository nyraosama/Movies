import 'package:movie_swira/model/ResponseRate.dart';
import 'package:movie_swira/model/movie_response.dart';
import 'package:movie_swira/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class RateBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<ResponseRate> _subject =
  BehaviorSubject<ResponseRate>();

  postRate(int idMovie,double rate) async {
    ResponseRate response = await _repository.postRate(idMovie, rate);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ResponseRate> get subject => _subject;
}

final ratebloc = RateBloc();
