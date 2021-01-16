import 'package:equatable/equatable.dart';

class GiphyDownsizedImage extends Equatable {
  final String url;
  final String width;
  final String height;

  GiphyDownsizedImage({
    this.url,
    this.width,
    this.height,
  });

  @override
  List<Object> get props => [url, width, height];

  factory GiphyDownsizedImage.fromJson(Map<String, dynamic> json) {
    return GiphyDownsizedImage(
      url: json['url'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'width': width,
      'height': height,
    };
  }

  @override
  String toString() {
    return 'GiphyDownsizedImage{url: $url, width: $width, height: $height}';
  }
}
