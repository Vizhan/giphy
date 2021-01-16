import 'dart:convert';

import 'package:flutter_giphy/core/error/exceptions.dart';
import 'package:flutter_giphy/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' show TypeMatcher;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  SearchRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  final baseUri = Uri(scheme: 'https', host: 'api.giphy.com');
  final endpoint = "v1/gifs/search";
  final apiKey = "3y9TMXqbCUt2D3UjJukbFJvsfOwVyOwP";

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = SearchRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setMockHttpClientSuccess200() {
    when(mockHttpClient.get(any)).thenAnswer((realInvocation) async => http.Response(fixture('giphy_collection.json'), 200));
  }

  void setMockHttpClientSuccess404() {
    when(mockHttpClient.get(any)).thenAnswer((realInvocation) async => http.Response(fixture('giphy_collection.json'), 404));
  }

  group('getGifsForSearchQuery', () {
    final tCollection = GiphyCollection.fromJson(json.decode(fixture('giphy_collection.json')));
    final query = 'trending';
    final offset = 0;
    final limit = 20;

    test('should perform GET request on a URL with query, offset & limit using apiKey', () async {
      //arrange
      setMockHttpClientSuccess200();
      //act
      dataSource.getGifsBySearchQuery(query, offset, limit);
      //assert
      verify(
        mockHttpClient.get(
          baseUri.replace(
            path: endpoint,
            queryParameters: <String, String>{
              'q': query,
              'offset': '$offset',
              'limit': '$limit',
              'api_key': apiKey,
              'rating': 'g',
              'lang': 'en',
            },
          ),
        ),
      );
    });

    test('should return gif collection when the response code is 200', () async {
      //arrange
      setMockHttpClientSuccess200();
      //act
      final result = await dataSource.getGifsBySearchQuery(query, offset, limit);
      //assert
      expect(result, equals(tCollection));
    });

    test('should throw ServerException when the response >=300', () async {
      //arrange
      setMockHttpClientSuccess404();
      //act
      final call = dataSource.getGifsBySearchQuery;
      //assert
      expect(() => call(query, offset, limit), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
