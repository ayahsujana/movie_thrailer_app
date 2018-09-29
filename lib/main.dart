import 'package:flutter/material.dart';
import 'package:movies_project_app_sujana/pages/now_playing.dart';
import 'package:movies_project_app_sujana/pages/popular.dart';
import 'package:movies_project_app_sujana/pages/top_rated.dart';
import 'package:movies_project_app_sujana/pages/upcoming.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
       primaryColor: Colors.grey[900], accentColor: Colors.grey[700], primaryColorDark: Colors.grey[900]
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movies Thrailler'),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[PopularMovies(), TopRatedMovies(), NowPlayingMovies(), UpcomingMovies()],
        ),
        bottomNavigationBar: Container(
          color: Colors.grey[900],
          child: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: 'Popular', icon: Icon(Icons.graphic_eq)),
              Tab(text: 'TopRated', icon: Icon(Icons.thumb_up)),
              Tab(text: 'NowPlaying', icon: Icon(Icons.play_arrow)),
              Tab(text: 'Upcoming', icon: Icon(Icons.arrow_upward)),
            ],
          ),
        ),
      ),
    );
  }
}
