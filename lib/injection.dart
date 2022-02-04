




import 'package:app_clean_architecture_flutter/data/datasources/remote_data_source.dart';
import 'package:app_clean_architecture_flutter/data/repositories/movie_repository_impl.dart';
import 'package:app_clean_architecture_flutter/domain/repositories/movie_respository.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_detail_movie.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_now_playing_movies.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_popular_movies.dart';
import 'package:app_clean_architecture_flutter/domain/usecase/get_recommended_movie.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_detail_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_list_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/popular_movies_notifier.dart';
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
  ));

  locator.registerFactory(() => PopularMoviesNotifier(locator()));


  ///use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));

  ///repository
  locator.registerLazySingleton<MovieRepository>(() =>
      MovieRepositoryImpl(remoteDataSource: locator())
  );


  ///data source
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));

  ///external
  locator.registerLazySingleton(() => http.Client());
}