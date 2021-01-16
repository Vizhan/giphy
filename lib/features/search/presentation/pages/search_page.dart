import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_giphy/core/utils/debouncer.dart';
import 'package:flutter_giphy/features/search/presentation/bloc/bloc.dart';
import 'package:flutter_giphy/features/search/presentation/widgets/search_bar.dart';
import 'package:flutter_giphy/features/search/presentation/widgets/search_results_list.dart';

import '../../../../injection_container.dart';

class SearchPage extends StatelessWidget {
  final searchController = TextEditingController();

  final scrollController = ScrollController();

  final debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<SearchBloc>(
          create: (_) => locator<SearchBloc>(),
          child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
            handleErrorState(state, context);
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SearchBar(
                  controller: searchController,
                  debouncer: debouncer,
                  onQueryChanged: () {
                    BlocProvider.of<SearchBloc>(context).add(GetInitialGifsBySearchQueryEvent(searchController.text));
                  },
                ),
                Expanded(
                  child: SearchResultsList(
                    searchState: state,
                    controller: scrollController,
                    listEndReached: () {
                      BlocProvider.of<SearchBloc>(context).add(GetMoreGifsBySearchQueryEvent(searchController.text));
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void handleErrorState(SearchState state, BuildContext context) {
    if (state is Error) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showAlertDialog(context, state));
    }
  }

  void _showAlertDialog(BuildContext context, Error errorState) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(errorState.message),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}
