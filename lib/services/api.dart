abstract class Api {
  Future<Map<String, dynamic>> runQuery(String query);
  Future<Map<String, dynamic>> runMutation(String query);
}
