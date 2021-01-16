import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_giphy/core/error/failures.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_gif.dart';
import 'package:flutter_giphy/features/search/domain/usecases/get_gifs_by_search_query.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/bloc.dart';
import 'package:meta/meta.dart';

const String UNEXPECTED_ERROR = 'Unexpected error';
const int pageSize = 20;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetGifsBySearchQuery getGifsBySearchQuery;

  int _page = 0;

  List<GiphyGif> _gifSnapshot = [];

  List<GiphyGif> get gifSnapshot => _gifSnapshot;

  bool _hasMoreData = true;

  bool get hasMoreData => _hasMoreData;

  SearchBloc({
    @required this.getGifsBySearchQuery,
  })  : assert(getGifsBySearchQuery != null),
        super(initialState);

  static SearchState get initialState => Empty();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is GetInitialGifsBySearchQueryEvent) {
      _resetResults();
      yield Loading();
      final failureOrCollection = await getGifsBySearchQuery.call(Params(
        query: event.query,
        offset: _page,
        limit: pageSize,
      ));
      yield* _eitherLoadedOrErrorState(failureOrCollection);
    } else if ((event is GetMoreGifsBySearchQueryEvent) && _hasMoreData) {
      _incrementPage();
      final failureOrCollection = await getGifsBySearchQuery.call(Params(
        query: event.query,
        offset: _page * pageSize,
        limit: pageSize,
      ));
      yield* _eitherLoadedOrErrorState(failureOrCollection);
    }
  }

  void _resetResults() {
    _page = 0;
    _gifSnapshot.clear();
  }

  void _incrementPage() {
    _page = _page + 1;
  }

  Stream<SearchState> _eitherLoadedOrErrorState(
    Either<Failure, GiphyCollection> failureOrCollection,
  ) async* {
    yield failureOrCollection.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (collection) => Loaded(_appendLoadedData(collection)),
    );
  }

  List<GiphyGif> _appendLoadedData(GiphyCollection collection) {
    final newCollection = List.of(_gifSnapshot..addAll(collection.data));
    _hasMoreData = collection.pagination.totalCount > newCollection.length;
    return newCollection;
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
