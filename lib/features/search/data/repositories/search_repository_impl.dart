import 'package:dartz/dartz.dart';
import 'package:flutter_giphy/core/error/exceptions.dart';
import 'package:flutter_giphy/core/error/failures.dart';
import 'package:flutter_giphy/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_giphy/features/search/domain/repositories/search_repository.dart';
import 'package:meta/meta.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, GiphyCollection>> getGifsBySearchQuery(
    String query,
    int offset,
    int limit,
  ) async {
    try {
      final giphyCollection = await remoteDataSource.getGifsBySearchQuery(
        query,
        offset,
        limit,
      );

      return Right(giphyCollection);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.statusCode, e.exception));
    }
  }
}
