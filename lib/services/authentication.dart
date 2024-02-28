import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:vacapp_mobile/constants/graphql_routes.dart';
import 'package:vacapp_mobile/services/graphql_api.dart';

class Authentication {
  static Future<void> authenticateClientApp() async {
    String? token = await const FlutterSecureStorage().read(key: "client_app_token");

    if (token == null || JwtDecoder.isExpired(token)) {
      // Generate new token with mutation
      GraphQlApi api = await GraphQlApi.create();
      Map<String, dynamic> dataObj = await api.runMutation(
        GraphQlRoutes.mutations[GraphQlMutation.login]!,
        variables: {
          "username": dotenv.env["CLIENT_APP_USERNAME"],
          "password": dotenv.env["CLIENT_APP_PASSWORD"]
        },
      );
      await const FlutterSecureStorage()
          .write(key: "client_app_token", value: dataObj["login"]["token"]);
    }
  }
}
