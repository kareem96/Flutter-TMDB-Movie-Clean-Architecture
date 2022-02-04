
import 'package:app_clean_architecture_flutter/common/failure.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie_detail.dart';
import 'package:app_clean_architecture_flutter/domain/repositories/movie_respository.dart';
import 'package:dartz/dartz.dart';

class RemoveWatchlist{
  final MovieRepository repository;
  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie){
    return repository.removeWatchlist(movie);
  }
}