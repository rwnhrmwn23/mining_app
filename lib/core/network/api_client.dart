import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiClient {
  final http.Client client;
  static const String baseUrl = 'https://dev-api-fms.apps-madhani.com/v1/';

  ApiClient(this.client);

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return await client.get(
      Uri.parse('$baseUrl$url'),
    );
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
    return await client.post(
      Uri.parse('$baseUrl$url'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return client.send(request);
  }
}
