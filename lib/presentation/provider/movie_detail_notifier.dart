


import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie_detail.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_detail_movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_recommended_movie.dart';
import 'package:flutter/material.dart';

class MovieDetailNotifier extends ChangeNotifier{
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  });

  late MovieDetail _movieDetail;
  MovieDetail get movie => _movieDetail;

  RequestState _movieState = RequestState.Empty;
  RequestState get movieState => _movieState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;


  List<Movie> _movieRecommendation = [];
  List<Movie> get movieRecommendations => _movieRecommendation;

  ///state recom
  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommenddationsState => _recommendationState;


  Future<void> fetchMovieDetail(int id) async{
    _movieState = RequestState.Loading;
    notifyListeners();

    final recommendationResult = await getMovieRecommendations.execute(id);

    final detailResult = await getMovieDetail.execute(id);
    detailResult.fold(
            (failure) {
              _movieState = RequestState.Error;
              _message = failure.message;
              notifyListeners();
            },
            (movie) {
              _recommendationState = RequestState.Loading;
              _movieDetail = movie;
              notifyListeners();
              _movieState = RequestState.Loaded;
              notifyListeners();
              recommendationResult.fold(
                      (failure) {
                        _recommendationState = RequestState.Error;
                        _message = failure.message;
                      },
                      (movies) {
                        _recommendationState = RequestState.Loaded;
                        _movieRecommendation = movies;
                      }
              );
            });
  }
}