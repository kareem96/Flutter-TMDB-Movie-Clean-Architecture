


import 'package:app_clean_architecture_flutter/common/constant.dart';
import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/domain/entities/movie.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/about_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/movie_detail_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/popular_movies_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/search_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/watchlist_page.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_list_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children:  [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                // backgroundColor: Colors.indigo,
                backgroundImage: AssetImage('assets/ui.png'),
              ),
                accountName: Text('Nonton Kuy'),
                accountEmail: Text('')
            ),
            ListTile(
              leading: const Icon(Icons.movie_outlined),
              title: const Text('Movies'),
              onTap: () => {Navigator.pop(context)},
            ),
            ListTile(
              leading: Icon(Icons.save_alt_outlined),
              title: const Text('Watchlist'),
              onTap: (){
                Navigator.pushNamed(context, WatchlistPage.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text('About'),
              onTap: (){
                Navigator.pushNamed(context, AboutPage.routeName);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Nonton Kuy'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, SearchPage.routeName);
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: Heading6,),
              Consumer<MovieListNotifier>(builder: (context, data, child){
                final state = data.nowPlayingState;
                if(state == RequestState.Loading){
                  return const Center(child: CircularProgressIndicator(),);
                }else if(state == RequestState.Loaded){
                  return MovieList(data.nowPlayingMovies);
                }else{
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, PopularMoviesPage.routeName);
                }
              ),
              Consumer<MovieListNotifier>(
                builder: (context, data, child){
                  final state = data.popularMoviesState;
                  if(state == RequestState.Loading){
                    return const Center(child: CircularProgressIndicator(),);
                  }else if(state == RequestState.Loaded){
                    return MovieList(data.popularMovies);
                  }else{
                    // print(data.popularMovies);
                    return Text(data.message);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Heading6,),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: const [
                Text('See more'),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        )
      ],
    );
  }


}


class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index){
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: (){
                debugPrint('${movie.id}');
                Navigator.pushNamed(context, MovieDetailPage.routeName, arguments: movie.id);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
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
  }
}

