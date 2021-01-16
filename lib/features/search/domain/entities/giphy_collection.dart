import 'package:equatable/equatable.dart';

import 'giphy_gif.dart';
import 'giphy_meta.dart';
import 'giphy_pagination.dart';

class GiphyCollection extends Equatable {
  final List<GiphyGif> data;
  final GiphyPagination pagination;
  final GiphyMeta meta;

  @override
  List<Object> get props => [data, pagination, meta];

  GiphyCollection({this.data, this.pagination, this.meta});

  factory GiphyCollection.fromJson(Map<String, dynamic> json) => GiphyCollection(
      data: (json['data'] as List)?.map((e) => e == null ? null : GiphyGif.fromJson(e as Map<String, dynamic>))?.toList(),
      pagination: json['pagination'] == null ? null : GiphyPagination.fromJson(json['pagination'] as Map<String, dynamic>),
      meta: json['meta'] == null ? null : GiphyMeta.fromJson(json['meta'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => <String, dynamic>{'data': data, 'pagination': pagination, 'meta': meta};

  @override
  String toString() {
    return 'GiphyCollection{data: $data, pagination: $pagination, meta: $meta}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyCollection && runtimeType == other.runtimeType && data == other.data && pagination == other.pagination && meta == other.meta;

  @override
  int get hashCode => data.hashCode ^ pagination.hashCode ^ meta.hashCode;
}
