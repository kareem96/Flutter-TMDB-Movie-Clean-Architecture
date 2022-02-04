

import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_popular_movies.dart';
import 'package:flutter/material.dart';

class PopularMoviesNotifier extends ChangeNotifier{
  final GetPopularMovies getPopularMovies;

  PopularMoviesNotifier(this.getPopularMovies);

  ///state empty
  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  ///get list
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  ///message
  String _message = '';
  String get message => _message;

  Future<void> fetchPopularMovies() async{
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularMovies.execute();
    result.fold(
            (failure) {
              _message = failure.message;
              _state = RequestState.Error;
              notifyListeners();
            },
            (data) {
              _movies = data;
              _state = RequestState.Loaded;
              notifyListeners();
            });
  }
}