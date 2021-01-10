import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/search_state.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../injection_container.dart';

class SearchPage extends StatelessWidget {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<SearchBloc>(
          create: (_) => locator<SearchBloc>(),
          child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
            return Container(
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    onSubmitted: (query) {
                      BlocProvider.of<SearchBloc>(context).add(GetInitialGifsBySearchQueryEvent(query));
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                  Expanded(
                    child: builder(state),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget builder(SearchState state) {
    if (state is Empty) {
      return Text('Start searching');
    } else if (state is Error) {
      return Text(state.message);
    } else if (state is Loaded) {
      final data = state.giphyCollection.data;
      return ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 200,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: state.giphyCollection.data[index].images.downsizedLarge.url,
              fit: BoxFit.cover,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 0);
        },
        itemCount: data.length,
      );
    } else if (state is Loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Container();
  }
}
