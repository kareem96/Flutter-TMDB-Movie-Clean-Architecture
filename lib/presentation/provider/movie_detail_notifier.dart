


import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie_detail.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_detail_movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_recommended_movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_watchlist_movies.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_watchlist_status.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/remove_watchlist.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/save_watchlist.dart';
import 'package:flutter/material.dart';

class MovieDetailNotifier extends ChangeNotifier{
  static const  watchlistAddSuccessMessage = 'Added to watchlist';
  static const  watchlistRemoveSuccessMessage = 'Remove from watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  ///
  late MovieDetail _movieDetail;
  MovieDetail get movie => _movieDetail;

  RequestState _movieState = RequestState.Empty;
  RequestState get movieState => _movieState;

  String _message = '';
  String get message => _message;

  ///
  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;
  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;


  ///
  List<Movie> _movieRecommendation = [];
  List<Movie> get movieRecommendations => _movieRecommendation;

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

  Future<void> addWatchlist(MovieDetail movie) async{
    final result = await saveWatchlist.execute(movie);
    await result.fold(
            (failure) {
              _watchlistMessage = failure.message;
            },
            (success) {
              _watchlistMessage = success;
            });
    await loadWatchlistStatus(movie.id);
  }

  Future<void>loadWatchlistStatus(int id) async{
    final result = await getWatchListStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }

  Future<void> removeFromWatchlist(MovieDetail movie)async{
    final result = await removeWatchlist.execute(movie);
    await result.fold(
            (failure) {
              _watchlistMessage = failure.message;
            },
            (success) {
              _watchlistMessage = success;
            });
    await loadWatchlistStatus(movie.id);
  }
}