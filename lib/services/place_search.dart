import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/place.dart';

//Arreglar de manera que se llene una inistancia de lugar y se abra el place_stats con info completa

class PlaceSearch extends SearchDelegate<String> {
  List<Place> places = [];

  PlaceSearch(this.places);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? places
        : places.where((p) => p.getName().toLowerCase().contains(query)).toList();

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {},
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                  text: suggestions[index].getName(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )),
                Text(suggestions[index].getType().getName(),
                    style: const TextStyle(color: Colors.grey)),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
