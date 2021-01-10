import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInitialGifsBySearchQueryEvent extends SearchEvent {
  final String query;

  GetInitialGifsBySearchQueryEvent(
    this.query,
  ) : super();

  @override
  List<Object> get props => super.props
    ..addAll([
      query,
    ]);
}

class GetMoreGifsBySearchQueryEvent extends SearchEvent {
  final String query;

  GetMoreGifsBySearchQueryEvent(
      this.query,
      ) : super();

  @override
  List<Object> get props => super.props
    ..addAll([
      query,
    ]);
}
