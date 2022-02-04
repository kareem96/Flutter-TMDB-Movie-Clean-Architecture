


import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/popular_movies_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular';
  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    Future.microtask(() => Provider.of<PopularMoviesNotifier>(context, listen: false).fetchPopularMovies());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies'),),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<PopularMoviesNotifier>(
          builder: (context, data, child){
            if(data.state == RequestState.Loading){
              return const Center(child: CircularProgressIndicator(),);
            }else if(data.state == RequestState.Loaded){
              return ListView.builder(
                itemCount: data.movies.length,
                itemBuilder: (context, index){
                  final movie = data.movies[index];
                  return CardList(movie);
                },
              );
            }else{
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
