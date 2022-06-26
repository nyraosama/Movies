import 'package:dio/dio.dart';
import 'package:movie_swira/model/ResponseRate.dart';
import 'package:movie_swira/model/movie.dart';
import 'package:movie_swira/model/movie_response.dart';

class MovieRepository {
  final String apiKey = "1e8761464a3c37188f6afb11cb5344a4";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio dio = Dio();
  var getPopularUrl = '$mainUrl/movie/top_rated';
  static var movieUrl = '$mainUrl/movie/';
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var guest_session_id = "4ec37db39d6108ac0b8e0bcb9aca33ec";

  Future<MovieResponse> getMoviesRecommended(int movieID) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1,
    };
    try {
      Response response = await dio.get("$movieUrl${movieID}/recommendations",
          queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getPlayingMovies() async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1,
    };
    try {
      Response response = await dio.get(getPlayingUrl, queryParameters: params);
      print('response OK : ${response.data}');
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<Movie> getDetailsMovie(int movieID) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
    };
    try {
      Response response =
          await dio.get("$movieUrl${movieID}", queryParameters: params);
      return Movie.fromJson(response.data);
    } catch (error, stacktrace) {
      print("exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<ResponseRate> postRate(int idMovie, double rate) async {
    var params = {
      "value": rate,
    };
    try {
      Response response = await dio.post(
        "$movieUrl$idMovie/rating?api_key=$apiKey&guest_session_id=$guest_session_id",
        queryParameters: params,
      );

      return ResponseRate.fromJson(response.data);
    } catch (error, stacktrace) {
      print("exception occured: $error stackTrace: $stacktrace");
      return ResponseRate.fromJson(error);
    }
  }
}
