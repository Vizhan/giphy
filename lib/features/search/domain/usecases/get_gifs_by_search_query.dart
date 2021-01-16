import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_giphy/core/error/failures.dart';
import 'package:flutter_giphy/core/usecases/usecase.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_collection.dart';
import 'package:flutter_giphy/features/search/domain/repositories/search_repository.dart';
import 'package:meta/meta.dart';

class GetGifsBySearchQuery implements UseCase<GiphyCollection, Params> {
  final SearchRepository repository;

  GetGifsBySearchQuery(this.repository);

  @override
  Future<Either<Failure, GiphyCollection>> call(
    Params params,
  ) async =>
      await repository.getGifsBySearchQuery(
        params.query,
        params.offset,
        params.limit,
      );
}

class Params extends Equatable {
  final String query;
  final int offset;
  final int limit;

  Params({
    @required this.query,
    @required this.offset,
    @required this.limit,
  });

  @override
  List<Object> get props => [query, offset, limit];
}
