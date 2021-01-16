import 'package:equatable/equatable.dart';

class GiphyPagination extends Equatable{
  final int totalCount;
  final int count;
  final int offset;

  @override
  List<Object> get props => [totalCount, count, offset];

  GiphyPagination({this.totalCount, this.count, this.offset});

  factory GiphyPagination.fromJson(Map<String, dynamic> json) =>
      GiphyPagination(
          totalCount: json['total_count'] as int,
          count: json['count'] as int,
          offset: json['offset'] as int);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total_count': totalCount,
      'count': count,
      'offset': offset
    };
  }

  @override
  String toString() {
    return 'GiphyPagination{totalCount: $totalCount, count: $count, offset: $offset}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GiphyPagination &&
              runtimeType == other.runtimeType &&
              totalCount == other.totalCount &&
              count == other.count &&
              offset == other.offset;

  @override
  int get hashCode => totalCount.hashCode ^ count.hashCode ^ offset.hashCode;
}
