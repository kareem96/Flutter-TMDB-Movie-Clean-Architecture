


import 'package:app_clean_architecture_flutter/common/exception.dart';
import 'package:app_clean_architecture_flutter/data/model/movie_detail_model.dart';
import 'package:app_clean_architecture_flutter/data/model/movie_model.dart';
import 'package:app_clean_architecture_flutter/data/model/movie_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class MovieRemoteDataSource{
  Future<List<MovieModel>> getNowPlaying();
  Future<MovieDetailModel> getDetailMovie(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> getPopularMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource{
  static const API_KEY = 'api_key=0be47f8a233f2718d99d0c366369f1f8';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  ///get now playing
  @override
  Future<List<MovieModel>> getNowPlaying() async{
    final response = await client.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));
    if(response.statusCode == 200){
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }else{
      throw ServerException();
    }
  }

  ///get detail movie
  @override
  Future<MovieDetailModel> getDetailMovie(int id) async{
    final response = await client.get(Uri.parse('$BASE_URL/movie/$id?$API_KEY'));
    if(response.statusCode == 200){
      return MovieDetailModel.fromJson(json.decode(response.body));
    }else{
      throw ServerException();
    }
  }

  ///get recommendations movie
  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/movie/$id/recommendations?$API_KEY'));
    if(response.statusCode == 200){
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }
    throw ServerException();
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async{
    final response = await client.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY'));
    if(response.statusCode == 200){
      print(response.body);
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }else{
      throw ServerException();
    }
  }






}