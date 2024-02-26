import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vacapp_mobile/services/api.dart';

class GraphQlApi extends Api {
  static final GraphQLClient client = GraphQLClient(
    link: HttpLink("http://10.0.2.2:3000/graphql"),
    cache: GraphQLCache(store: InMemoryStore()),
  );

  // TODO: BETTER ERROR HANDLING
  @override
  Future<Map<String, dynamic>> runQuery(String query,
      {Map<String, dynamic> variables = const {}}) async {
    try {
      QueryResult result =
          await client.query(QueryOptions(document: gql(query), variables: variables));
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data == null) {
        throw Exception(
            "No se hallaron datos. Comprueba que la consulta está escrita correctamente");
      }
      return result.data!;
    } catch (errorMsg) {
      return {"error": errorMsg};
    }
  }

  @override
  Future<Map<String, dynamic>> runMutation(String query,
      {Map<String, dynamic> variables = const {}}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(document: gql(query), variables: variables),
      );
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data == null) {
        throw Exception();
      }
      return result.data!;
    } catch (errorMsg) {
      return {"error": errorMsg};
    }
  }
}
