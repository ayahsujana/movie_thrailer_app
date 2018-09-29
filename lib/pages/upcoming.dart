import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies_project_app_sujana/model/UpcomingMovie.dart';
import 'package:movies_project_app_sujana/ui/MovieDetailsPage.dart';
import 'package:movies_project_app_sujana/utils/config.dart';
import 'package:http/http.dart' as http;

class UpcomingMovies extends StatefulWidget {
  _UpcomingMoviesState createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends State<UpcomingMovies> {
  Future<List<UpcomingMovie>> getUpcomingMovies() async {
    try {
      final responses = await http.get(BASE_URL_UPCOMING + API_KEY);
      if (responses.statusCode == HttpStatus.OK) {
        var data = jsonDecode(responses.body);
        List results = data["results"];
        List<UpcomingMovie> movieList = _createUpcomingMovieList(results);
        return movieList;
      } else {
        print("Failed http call.");
      }
    } catch (exception) {
      print(exception.toString());
    }
    return null;
  }

  _createUpcomingMovieCardItem(
      List<UpcomingMovie> movies, BuildContext context) {
    List<Widget> listElementWidgetList = new List<Widget>();
    if (movies != null) {
      var lengthOfList = movies.length;
      for (int i = 0; i < lengthOfList; i++) {
        UpcomingMovie movie = movies[i];
        var imageURL = BACKDROP_URL + movie.posterPath;
        var listItem = new Material(
          shadowColor: Colors.grey[500],
          elevation: 15.0,
          child: InkWell(
            onTap: () {
              if (movie.id > 0) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (_) => MovieDetailsPage(movie.id)),
                );
              }
            },
            child: Card(
              elevation: 0.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Image.network(imageURL, fit: BoxFit.cover),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Center(
                        child: Text(
                          movie.title,
                          softWrap: true,
                          style: TextStyle(fontSize: 10.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        listElementWidgetList.add(listItem);
      }
    }
    return listElementWidgetList;
  }

  _createUpcomingMovieList(List data) {
    List<UpcomingMovie> list = new List();
    for (int i = 0; i < data.length; i++) {
      var id = data[i]["id"];
      String title = data[i]["title"];
      String posterPath = data[i]["poster_path"];
      String backdropImage = data[i]["backdrop_path"];
      String originalTitle = data[i]["original_title"];
      var voteAverage = data[i]["vote_average"];
      String overview = data[i]["overview"];
      String releaseDate = data[i]["release_date"];

      UpcomingMovie movie = new UpcomingMovie(id, title, posterPath,
          backdropImage, originalTitle, voteAverage, overview, releaseDate);
      list.add(movie);
    }
    return list;
  }

  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: PageView(
        children: <Widget>[
          Offstage(
            offstage: _page != 0,
            child: new TickerMode(
              enabled: _page == 0,
              child: new FutureBuilder(
                  future: getUpcomingMovies(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (!snapshot.hasData)
                      return new Container(
                        child: new Center(
                          child: new CircularProgressIndicator(),
                        ),
                      );
                    List movies = snapshot.data;
                    return new CustomScrollView(
                      primary: false,
                      slivers: <Widget>[
                        new SliverPadding(
                          padding: const EdgeInsets.all(10.0),
                          sliver: new SliverGrid.count(
                            crossAxisCount: 3,
                            childAspectRatio: 2 / 3.5,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            children:
                                _createUpcomingMovieCardItem(movies, context),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
