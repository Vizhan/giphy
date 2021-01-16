import 'package:flutter/material.dart';
import 'package:flutter_giphy/core/utils/debouncer.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Debouncer debouncer;
  final VoidCallback onQueryChanged;

  const SearchBar({
    Key key,
    this.controller,
    this.debouncer,
    this.onQueryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      maxLines: 1,
      onSubmitted: (query) => onQueryChanged(),
      onChanged: (query) => debouncer.call(() {
        onQueryChanged();
        FocusScope.of(context).requestFocus(FocusNode());
      }),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: 'Search...',
      ),
    );
  }
}
