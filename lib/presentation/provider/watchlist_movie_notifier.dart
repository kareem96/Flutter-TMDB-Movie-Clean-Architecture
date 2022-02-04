


import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_watchlist_movies.dart';
import 'package:flutter/material.dart';

class WatchlistMovieNotifier extends ChangeNotifier{
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovie => _watchlistMovies;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistMovieNotifier({required this.getWatchlistMovies});
  final GetWatchlistMovies getWatchlistMovies;
}