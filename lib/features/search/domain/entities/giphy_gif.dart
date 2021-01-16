import 'package:equatable/equatable.dart';

import 'giphy_images.dart';

class GiphyGif extends Equatable {
  final GiphyImages images;

  GiphyGif({
    this.images,
  });

  @override
  List<Object> get props => [images];

  factory GiphyGif.fromJson(Map<String, dynamic> json) =>
      GiphyGif(images: json['images'] == null ? null : GiphyImages.fromJson(json['images'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'images': images};
  }

  @override
  String toString() {
    return 'GiphyGif{images: $images}';
  }
}
