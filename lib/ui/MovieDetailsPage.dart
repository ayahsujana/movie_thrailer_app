import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_project_app_sujana/model/MovieDetail.dart';
import 'package:movies_project_app_sujana/ui/ProductionCompaniesScroller.dart';
import 'package:movies_project_app_sujana/ui/RatingInformation.dart';
import 'package:movies_project_app_sujana/ui/StoryLine.dart';
import 'package:http/http.dart' as http;
import 'package:movies_project_app_sujana/utils/config.dart';

class MovieDetailsPage extends StatelessWidget {
  MovieDetailsPage(this.id);

  var id;

  MovieDetail detail;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return new Scaffold(
      body: new FutureBuilder<MovieDetail>(
        future: getMovieDetail(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("Result $snapshot");
            return new Container(
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return new Center(
              child: new Text("${snapshot.error}"),
            );
          } else {
            MovieDetail movies = snapshot.data;
            return new CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverAppBar(
                    expandedHeight: 220.0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Movies Detail',
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      background: Image.network(
                          BACKDROP_URL + movies.backdropPath,
                          fit: BoxFit.cover),
                    )),
                SliverToBoxAdapter(
                    child: Card(
                  elevation: 2.0,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: _buildPoster(movies),
                        ),
                        Flexible(
                          flex: 4,
                          child: _buildDetail(movies, textTheme),
                        )
                      ],
                    ),
                  ),
                )),
                SliverToBoxAdapter(
                  child: Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: StoryLine(movies.synopsis),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ProductionCompaniesScroller(
                          movies.productionCompanies),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100.0,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Future<MovieDetail> getMovieDetail(id) async {
    final response =
        await http.get(BASE_URL + id.toString() + '?api_key=' + API_KEY);
    final dataMovies = jsonDecode(response.body);
    MovieDetail movieDetail = createDetailList(dataMovies);

    return movieDetail;
  }

  MovieDetail createDetailList(data) {
    List<String> genresList = new List();
    List<ProductionCompanies> productionCompaniesList = new List();

    var id = data["id"];
    var title = data["original_title"];
    var productionCompany = data["production_companies"];
    for (int i = 0; i < productionCompany.length; i++) {
      var id = productionCompany[i]["id"];
      String name = productionCompany[i]["name"];
      String logoPath = productionCompany[i]["logo_path"];
      ProductionCompanies productionCompanies =
          new ProductionCompanies(id, name, logoPath);
      productionCompaniesList.add(productionCompanies);
    }
    var genres = data["genres"];
    for (int i = 0; i < genres.length; i++) {
      String name = genres[i]["name"];
      genresList.add(name);
    }
    var overview = data["overview"];
    var posterPath = data["poster_path"];
    var backdropPath = data["backdrop_path"];
    var voteAverage = data["vote_average"];
    MovieDetail detail = MovieDetail(id, title, genresList, overview,
        posterPath, backdropPath, voteAverage, productionCompaniesList);
    return detail;
  }

  _buildCategoryChips(TextTheme textTheme, MovieDetail movies) {
    return movies.genres.map((genres) {
      return new Chip(
        label: new Text(genres),
        labelStyle: textTheme.caption,
        backgroundColor: Colors.black12,
      );
    }).toList();
  }

  _buildPoster(MovieDetail movies) {
    return Card(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Image.network(
            POSTER_URL + movies.posterPath,
            fit: BoxFit.cover,
            height: 180.0,
          )),
    );
  }

  _buildDetail(MovieDetail movies, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new Text(
              movies.originalTitle,
              //style: textTheme.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: new RatingInformation(movies),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: new Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              direction: Axis.horizontal,
              children: _buildCategoryChips(textTheme, movies),
            ),
          )
        ],
      ),
    );
  }
}
