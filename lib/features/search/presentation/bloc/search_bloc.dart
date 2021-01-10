import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_giphy/core/error/failures.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_giphy/features/search/domain/usecases/get_gifs_by_search_query.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/search_state.dart';
import 'package:meta/meta.dart';

const String UNEXPECTED_ERROR = 'Unexpected error';
const int pageSize = 20;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetGifsBySearchQuery getGifsBySearchQuery;
  int offset = 0;
  bool isFetching = false;
  GiphyCollection collectionSnapshot;

  SearchBloc({
    @required this.getGifsBySearchQuery,
  })  : assert(getGifsBySearchQuery != null),
        super(initialState);

  static SearchState get initialState => Empty();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    print(event.runtimeType);
    if (event is GetInitialGifsBySearchQueryEvent) {
      offset = 0;
      yield Loading();
      final failureOrCollection = await getGifsBySearchQuery.call(Params(
        query: event.query,
        offset: offset,
        limit: pageSize,
      ));
      yield* _eitherLoadedOrErrorState(failureOrCollection);
    } else if (event is GetMoreGifsBySearchQueryEvent) {
      yield Loading();
      final failureOrCollection = await getGifsBySearchQuery.call(Params(
        query: event.query,
        offset: ++offset * pageSize,
        limit: pageSize,
      ));
      //TODO
    }
  }

  Stream<SearchState> _eitherLoadedOrErrorState(
    Either<Failure, GiphyCollection> failureOrCollection,
  ) async* {
    yield failureOrCollection.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (collection) => Loaded(collection),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).exception;
        break;
      default:
        return UNEXPECTED_ERROR;
    }
  }
}
