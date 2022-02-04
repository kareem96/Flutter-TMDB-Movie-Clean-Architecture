


import 'package:app_clean_architecture_flutter/common/constant.dart';
import 'package:app_clean_architecture_flutter/common/state_enum.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_search_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query){
                Provider.of<MovieSearchNotifier>(context, listen: false).fetchMovieSearch(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search_outlined),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16,),
            Text('Search Result', style: Heading6,),
            Consumer<MovieSearchNotifier>(
                builder: (context, data, child){
                  if(data.state == RequestState.Loading){
                    return const Center(child: CircularProgressIndicator(),);
                  }else if(data.state == RequestState.Loaded){
                    final result = data.searchResult;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (context, index){
                          final movie = data.searchResult[index];
                          return CardList(movie);
                        },
                      ),
                    );
                  }else{
                    return Expanded(child: Container());
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
