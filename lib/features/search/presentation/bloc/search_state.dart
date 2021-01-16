import 'package:equatable/equatable.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_gif.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends SearchState {}

class Loading extends SearchState {}

class Loaded extends SearchState {
  final List<GiphyGif> giphyCollection;

  Loaded(this.giphyCollection);

  @override
  List<Object> get props => [giphyCollection];
}

class Error extends SearchState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
