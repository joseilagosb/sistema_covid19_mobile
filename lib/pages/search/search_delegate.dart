import 'package:flutter/material.dart';
import 'package:vacapp_mobile/pages/search/screens/search_delegate_default_screen.dart';

class SearchDelegateService extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text("hola"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query == "" ? const SearchDelegateDefaultScreen() : const Text("chao");
  }
}
