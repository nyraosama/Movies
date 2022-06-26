import 'package:flutter/material.dart';
import 'package:movie_swira/model/movie_response.dart';
import 'package:movie_swira/screens/detailsmoviescreen.dart';

class BuildRecommend extends StatelessWidget {
  MovieResponse model;
    BuildRecommend(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.movies.length == 0) {
      return Container(
        child: Text('No Movies'),
      );
    } else
      return Container(
      height: 275.0,
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recommended Movies", style: TextStyle(
            height: 1.5,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14.0,
          ),),
          Flexible(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.movies.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsMovieScreen(model.movies[index]),
                          ));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        right: 10.0,
                      ),
                      child: Column(children: [
                        model.movies[index].posterPath == null
                            ? Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 50.0,
                            ),
                          ),
                        )
                            : Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                            //  color: Style.Colors.secondColor,
                            borderRadius: BorderRadius.circular(3.0),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200" +
                                        model.movies[index].posterPath),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          width: 100.0,
                          child: Text(
                            model.movies[index]?.title ?? "No title",
                            maxLines: 2,
                            style: TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                      ]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );

  }
}
