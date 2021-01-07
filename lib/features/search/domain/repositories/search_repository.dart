import 'package:dartz/dartz.dart';
import 'package:flutter_giphy/core/error/failures.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';

abstract class SearchRepository {
  Future<Either<Failure, GiphyCollection>> getGifsBySearchQuery(
    String query,
    int offset,
    int limit,
  );
}
