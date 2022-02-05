



import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/common/utils.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/watchlist_movie_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware{


  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<WatchlistMovieNotifier>(context, listen: false).fetchWatchlistMovies());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false).fetchWatchlistMovies();
  }
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist'),),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<WatchlistMovieNotifier>(
          builder: (context, data, child){
            if(data.watchlistState == RequestState.Loading){
              return const Center(child: CircularProgressIndicator(),);
            }else if(data.watchlistState == RequestState.Loaded){
              return ListView.builder(
                itemCount: data.watchlistMovie.length,
                itemBuilder: (context, index){
                  final movie = data.watchlistMovie[index];
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
