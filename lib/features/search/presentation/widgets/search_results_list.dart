import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_giphy/features/search/domain/entities/giphy_gif.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/bloc.dart';
import 'package:flutter_giphy/features/search/presentation/widgets/thumbnail.dart';

import 'loading_wheel.dart';
import 'message.dart';

class SearchResultsList extends StatelessWidget {
  final SearchState searchState;
  final ScrollController controller;
  final VoidCallback listEndReached;

  const SearchResultsList({
    Key key,
    @required this.searchState,
    @required this.controller,
    @required this.listEndReached,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (searchState.runtimeType) {
      case Empty:
        return Message('Start searching');
      case Loading:
        return LoadingWheel();
      case Error:
        final lastLoadedData = BlocProvider.of<SearchBloc>(context).gifSnapshot;
        return _buildList(context, lastLoadedData);
      case Loaded:
        return _buildList(context, (searchState as Loaded).giphyCollection);
      default:
        return Container();
    }
  }

  Widget _buildList(BuildContext context, List<GiphyGif> data) {
    if (data.isEmpty) {
      return Message('No results. Try to change query.');
    }

    // ignore: invalid_use_of_protected_member
    if (!controller.hasListeners) {
      controller
        ..addListener(() {
          if (controller.offset == controller.position.maxScrollExtent) {
            listEndReached.call();
          }
        });
    }

    final hasMoreData = BlocProvider.of<SearchBloc>(context).hasMoreData;

    return GridView.builder(
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: data.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        final isLoading = hasMoreData && index == data.length;
        if (isLoading) {
          return LoadingWheel();
        }

        return Thumbnail(
          url: data[index].images.previewGif.url,
        );
      },
    );
  }
}
