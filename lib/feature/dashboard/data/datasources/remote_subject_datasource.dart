import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/cookie_manager.dart';
import '../models/subject_model.dart';

abstract class RemoteSubjectDataSource {
  Future<List<SubjectModel>> getTemplateMessage();
}

@LazySingleton(as: RemoteSubjectDataSource)
class RemoteSubjectDataSourceImpl implements RemoteSubjectDataSource {
  final ApiClient client;
  final CookieManager cookieManager;

  RemoteSubjectDataSourceImpl({required this.client, required this.cookieManager});

  @override
  Future<List<SubjectModel>> getTemplateMessage() async {
    final token = await cookieManager.getToken();

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final headers = {
      'Cookie':
      'refresh_token=$token; token=$token',
    };

    final Uri url = Uri.parse('${ApiClient.baseUrl}monitoring/subjects');

    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final http.StreamedResponse response = await client.send(request);

    if (response.statusCode == 200) {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => SubjectModel.fromJson(json)).toList();
    } else if (response.statusCode == 400) {
      throw Exception('Subjects not found: ${await response.stream.bytesToString()}');
    }

    throw Exception(
        'Failed to fetch subjects: ${response.statusCode} ${await response.stream.bytesToString()}');
  }
}
