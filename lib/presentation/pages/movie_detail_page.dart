


import 'package:app_clean_architecture_flutter/common/constant.dart';
import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/domain/entities/genre.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie_detail.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_detail_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail';
  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieDetailNotifier>(context, listen: false)
          .fetchMovieDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.movieState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.movieState == RequestState.Loaded) {
            final movie = provider.movie;
            return SafeArea(
              child: ContentDetails(
                movie,
                provider.isAddedToWatchlist,
                provider.movieRecommendations,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}


class ContentDetails extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;
  final List<Movie> recommendations;
  ContentDetails(this.movie, this.isAddedWatchlist, this.recommendations);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Image.asset('assets/image.png'),
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 10),
          child: DraggableScrollableSheet(
            builder: (context, scrollController){
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title),
                            ElevatedButton(
                                onPressed: (){},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                                    Text('Watchlist')
                                  ],
                                )
                            ),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(Icons.star),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16,),
                            Text('Overview', style: Heading6,),
                            Text(movie.overview),
                            const SizedBox(height: 16,),
                            Text('Recommendations', style: Heading6,),
                            Consumer<MovieDetailNotifier>(
                              builder: (context, data, child){
                                if(data.recommenddationsState == RequestState.Loading){
                                  return const Center(child: CircularProgressIndicator(),);
                                }else if(data.recommenddationsState == RequestState.Error){
                                  return Text(data.message);
                                }else if(data.recommenddationsState == RequestState.Loaded){
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recommendations.length,
                                      itemBuilder: (context, index){
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: (){},
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(const Radius.circular(8)),
                                              child: CachedNetworkImage(
                                                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) => const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    )
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (){Navigator.pop(context);},
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres){
    String result = '';
    for (var genre in genres){
      result += genre.name + ', ';
    }
    if(result.isEmpty){
      return result;
    }
    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime){
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;
    if(hours > 0){
      return '${hours}h ${minutes}m';
    }else{
      return '${minutes}m';
    }
  }

}

