import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:vacapp_mobile/services/api.dart';

class MockApi extends Api {
  @override
  Future<Map<String, dynamic>> runQuery(String query) async {
    String jsonString = await rootBundle.loadString(query);
    Map<String, dynamic> parsedJson = jsonDecode(jsonString);
    await Future.delayed(const Duration(milliseconds: 2000));
    return parsedJson;
  }

  @override
  Future<Map<String, dynamic>> runMutation(String query) async {
    throw UnimplementedError();
  }
}
