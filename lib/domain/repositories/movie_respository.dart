


import 'package:app_clean_architecture_flutter/common/failure.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';

abstract class MovieRepository{
  Future<Either<Failure, List<Movie>>> getNowPlaying();
  Future<Either<Failure, MovieDetail>> getDetailMovie(int id);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Movie>>> getPopularMovies();
}