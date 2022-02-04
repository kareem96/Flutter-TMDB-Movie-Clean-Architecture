

import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/search_movies.dart';
import 'package:flutter/material.dart';

class MovieSearchNotifier extends ChangeNotifier{
  final SearchMovies searchMovies;
  MovieSearchNotifier({required this.searchMovies});

  ///state empty
  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  ///state get list result
  List<Movie> _searchResult = [];
  List<Movie> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchMovieSearch(String query) async{
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchMovies.execute(query);
    result.fold(
            (failure){
              _message = failure.message;
              _state = RequestState.Error;
              notifyListeners();
            },
            (data) {
              _searchResult = data;
              _state = RequestState.Loaded;
              notifyListeners();
            });
  }
}