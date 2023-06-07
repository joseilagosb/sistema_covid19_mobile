import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vacapp_mobile/services/api.dart';

class GraphQlApi extends Api {
  static final GraphQLClient client = GraphQLClient(
    link: HttpLink("http://10.0.2.2:3000/graphql"),
    cache: GraphQLCache(store: InMemoryStore()),
  );

  // TODO: BETTER ERROR HANDLING
  @override
  Future<Map<String, dynamic>> runQuery(String query) async {
    try {
      QueryResult result = await client.query(QueryOptions(document: gql(query)));
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
}
