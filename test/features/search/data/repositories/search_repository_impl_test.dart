import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_giphy/core/error/exceptions.dart';
import 'package:flutter_giphy/core/error/failures.dart';
import 'package:flutter_giphy/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_giphy/features/search/data/repositories/search_repository_impl.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSearchRemoteDataSource extends Mock implements SearchRemoteDataSource {}

main() {
  SearchRepositoryImpl repository;
  MockSearchRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    repository = SearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('getGifsForSearchQuery', () {
    final tCollection = GiphyCollection.fromJson(json.decode(fixture('giphy_collection.json')));
    final query = 'trending';
    final offset = 0;
    final limit = 20;

    test('should return remote data source when the call to remote data source is successful', () async {
      //arrange
      when(mockRemoteDataSource.getGifsBySearchQuery(any, any, any)).thenAnswer((realInvocation) async => tCollection);
      //act
      final result = await repository.getGifsBySearchQuery(query, offset, limit);
      //assert
      verify(mockRemoteDataSource.getGifsBySearchQuery(query, offset, limit));
      expect(result, equals(Right(tCollection)));
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      final statusCode = 404;
      final exceptionMessage = 'Error message';
      //arrange
      when(mockRemoteDataSource.getGifsBySearchQuery(any, any, any)).thenThrow(ServerException(statusCode, exceptionMessage));
      //act
      final result = await repository.getGifsBySearchQuery(query, offset, limit);
      //assert
      verify(mockRemoteDataSource.getGifsBySearchQuery(query, offset, limit));
      expect(result, equals(Left(ServerFailure(statusCode, exceptionMessage))));
    });
  });
}
