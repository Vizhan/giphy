import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_giphy/core/error/failures.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_giphy/features/search/domain/usecases/get_gifs_by_search_query.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetGifsBySearchQuery extends Mock implements GetGifsBySearchQuery {}

void main() {
  SearchBloc bloc;
  MockGetGifsBySearchQuery mockGetGifsBySearchQuery;

  setUp(() {
    mockGetGifsBySearchQuery = MockGetGifsBySearchQuery();
    bloc = SearchBloc(getGifsBySearchQuery: mockGetGifsBySearchQuery);
  });

  test('initial state should be empty', () {
    //assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetGifsForSearchQuery', () {
    final tCollection = GiphyCollection.fromJson(json.decode(fixture('giphy_collection.json')));
    final query = 'trending';
    final offset = 0;
    final limit = 20;
    final statusCode = 404;
    final exceptionMessage = 'Error message';

    test('should get data from the search use case', () async {
      //arrange
      when(mockGetGifsBySearchQuery(any)).thenAnswer((realInvocation) async => Right(tCollection));
      //act
      bloc.add(GetInitialGifsBySearchQueryEvent(query));
      await untilCalled(mockGetGifsBySearchQuery(any));
      //assert
      verify(mockGetGifsBySearchQuery(Params(query: query, offset: offset, limit: limit)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully on initial loading', () async {
      //arrange
      when(mockGetGifsBySearchQuery(any)).thenAnswer((realInvocation) async => Right(tCollection));

      //assert later
      final expected = [
        Loading(),
        Loaded(tCollection.data),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      //act
      bloc.add(GetInitialGifsBySearchQueryEvent(query));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully on load more', () async {
      //arrange
      when(mockGetGifsBySearchQuery(any)).thenAnswer((realInvocation) async => Right(tCollection));

      //assert later
      final expected = [
        Loaded(tCollection.data),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      //act
      bloc.add(GetMoreGifsBySearchQueryEvent(query));
    });

    test('should emit [Loading, Error] when data fails on initial loading', () async {
      //arrange
      when(mockGetGifsBySearchQuery(any)).thenAnswer((realInvocation) async => Left(ServerFailure(statusCode, exceptionMessage)));

      //assert later
      final expected = [
        Loading(),
        Error(exceptionMessage),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      //act
      bloc.add(GetInitialGifsBySearchQueryEvent(query));
    });

    test('should emit [Loading, Error] when data fails on load more', () async {
      //arrange
      when(mockGetGifsBySearchQuery(any)).thenAnswer((realInvocation) async => Left(ServerFailure(statusCode, exceptionMessage)));

      //assert later
      final expected = [
        Error(exceptionMessage),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      //act
      bloc.add(GetMoreGifsBySearchQueryEvent(query));
    });
  });
}
