


import 'package:app_clean_architecture_flutter/data/datasources/db/database_helper.dart';
import 'package:app_clean_architecture_flutter/data/datasources/local_data_source.dart';
import 'package:app_clean_architecture_flutter/data/datasources/remote_data_source.dart';
import 'package:app_clean_architecture_flutter/data/repositories/movie_repository_impl.dart';
import 'package:app_clean_architecture_flutter/domain/repositories/movie_respository.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_detail_movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_now_playing_movies.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_popular_movies.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_recommended_movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_watchlist_movies.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_watchlist_status.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/remove_watchlist.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/save_watchlist.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/search_movies.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_detail_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_list_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_search_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/popular_movies_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/watchlist_movie_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void init(){
  ///provider
  locator.registerFactory(() => MovieListNotifier(
    getNowPlayingMovies: locator(),
    getPopularMovies: locator(),
  ));

  locator.registerFactory(() => MovieDetailNotifier(
    getMovieDetail: locator(),
    getMovieRecommendations: locator(),
    getWatchListStatus: locator(),
    saveWatchlist: locator(),
    removeWatchlist: locator(),
  ));

  locator.registerFactory(() => MovieSearchNotifier(searchMovies: locator()));

  locator.registerFactory(() => PopularMoviesNotifier(locator()));

  locator.registerFactory(() => WatchlistMovieNotifier(getWatchlistMovies: locator()));



  ///use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));




  ///repository
  locator.registerLazySingleton<MovieRepository>(() =>
      MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator()
      )
  );


  ///data source
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  ///helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  ///external
  locator.registerLazySingleton(() => http.Client());
}