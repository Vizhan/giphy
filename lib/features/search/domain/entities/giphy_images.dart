import 'package:equatable/equatable.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_image.dart';

class GiphyImages extends Equatable {
  final GiphyDownsizedImage previewGif;

  GiphyImages({
    this.previewGif,
  });

  @override
  List<Object> get props => [previewGif];

  factory GiphyImages.fromJson(Map<String, dynamic> json) {
    return GiphyImages(
      previewGif: json['preview_gif'] == null ? null : GiphyDownsizedImage.fromJson(json['preview_gif'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'preview_gif': previewGif};
  }

  @override
  String toString() {
    return 'GiphyImages{previewGif: $previewGif}';
  }
}
