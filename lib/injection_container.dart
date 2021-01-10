import 'package:flutter_giphy/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_giphy/features/search/data/repositories/search_repository_impl.dart';
import 'package:flutter_giphy/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_giphy/features/search/domain/usecases/get_gifs_by_search_query.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/search_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

GetIt locator = GetIt.instance;

void init() {
  //Features
  //BLoC
  locator.registerFactory(() => SearchBloc(
        getGifsBySearchQuery: locator(),
      ));
  //Use cases
  locator.registerLazySingleton(() => GetGifsBySearchQuery(locator()));

  //Repository
  locator.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
        remoteDataSource: locator(),
      ));

  //Data Sources
  locator.registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(
        client: locator(),
      ));

  //External
  locator.registerLazySingleton(() => http.Client());
}
