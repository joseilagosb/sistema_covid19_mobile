import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:vacapp_mobile/services/api.dart';

class GraphQlApi extends Api {
  final GraphQLClient client;

  GraphQlApi._(this.client);
  static Future<GraphQlApi> create() async {
    GraphQLClient client = _createClient();
    return GraphQlApi._(client);
  }

  static GraphQLClient _createClient() {
    Link authLink = AuthLink(getToken: () async {
      String? token = await const FlutterSecureStorage().read(key: "client_app_token");
      if (token == null) {
        return "";
      }
      return "Bearer $token";
    });
    Link httpLink = HttpLink("http://10.0.2.2:3000/graphql");
    Link mergedLink = Link.from([authLink, httpLink]);
    return GraphQLClient(
      link: mergedLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

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
