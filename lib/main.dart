import 'package:app_clean_architecture_flutter/common/constant.dart';
import 'package:app_clean_architecture_flutter/common/utils.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/about_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/home_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/movie_detail_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/popular_movies_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/search_page.dart';
import 'package:app_clean_architecture_flutter/presentation/pages/watchlist_page.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_detail_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_list_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/movie_search_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/popular_movies_notifier.dart';
import 'package:app_clean_architecture_flutter/presentation/provider/watchlist_movie_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection.dart' as di;


void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          accentColor: kYellow,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: textTheme
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings){
          switch (settings.name){
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomePage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(builder: (_) => MovieDetailPage(id: id), settings: settings);
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case SearchPage.routeName:
              return MaterialPageRoute(builder: (_) => SearchPage());
            case WatchlistPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            default:
              return MaterialPageRoute(builder: (_){
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found!'),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

