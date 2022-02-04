

import 'package:app_clean_architecture_flutter/common/failure.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie_detail.dart';
import 'package:app_clean_architecture_flutter/domain/repositories/movie_respository.dart';
import 'package:dartz/dartz.dart';

class SaveWatchlist{
  final MovieRepository repository;
  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie){
    return repository.saveWatchlist(movie);
  }
}