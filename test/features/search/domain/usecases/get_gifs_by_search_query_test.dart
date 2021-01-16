import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_giphy/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_giphy/features/search/domain/usecases/get_gifs_by_search_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  GetGifsBySearchQuery usecase;
  MockSearchRepository mockSearchRepository;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    usecase = GetGifsBySearchQuery(mockSearchRepository);
  });

  test('should get gifs by search query from the repository', () async {
    final tCollection = GiphyCollection.fromJson(json.decode(fixture('giphy_collection.json')));
    final query = 'trending';
    final offset = 0;
    final limit = 20;

    //arrange
    when(mockSearchRepository.getGifsBySearchQuery(any, any, any)).thenAnswer((_) async => Right(tCollection));
    // act
    final result = await usecase(Params(query: query, offset: offset, limit: limit));
    // assert
    expect(result, Right(tCollection));
    verify(mockSearchRepository.getGifsBySearchQuery(query, offset, limit));
    verifyNoMoreInteractions(mockSearchRepository);
  });
}
