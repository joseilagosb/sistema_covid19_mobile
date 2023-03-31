import "package:graphql_flutter/graphql_flutter.dart";
import 'package:vacapp_mobile/utils/constants.dart';

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink("${Constants.BACKEND_URI}/graphql");

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
  }
}
