import 'dart:convert';
import 'dart:io';

import 'package:flutter_giphy/core/error/exceptions.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class SearchRemoteDataSource {
  /// Throws a [ServerException] for all error codes
  Future<GiphyCollection> getGifsBySearchQuery(
    String query,
    int offset,
    int limit,
  );
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  static final baseUri = Uri(scheme: 'https', host: 'api.giphy.com');
  final http.Client client;

  SearchRemoteDataSourceImpl({@required this.client});

  @override
  Future<GiphyCollection> getGifsBySearchQuery(String query, int offset, int limit) async {
    final endpoint = "v1/gifs/search";
    final apiKey = "3y9TMXqbCUt2D3UjJukbFJvsfOwVyOwP";

    final response = await client.get(
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
    );

    if (response.statusCode == HttpStatus.ok) {
      return GiphyCollection.fromJson(json.decode(response.body));
    } else {
      throw ServerException(response.statusCode, response.body);
    }
  }
}
