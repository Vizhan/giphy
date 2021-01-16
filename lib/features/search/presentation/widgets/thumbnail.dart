import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'message.dart';

class Thumbnail extends StatelessWidget {
  final String url;

  const Thumbnail({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[200],
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: url ?? '',
        imageErrorBuilder: (context, error, stacktrace) => Message('Resource not found'),
        fit: BoxFit.cover,
      ),
    );
  }
}
