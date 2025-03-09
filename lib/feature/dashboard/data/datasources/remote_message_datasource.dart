import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/cookie_manager.dart';
import '../models/message_model.dart';

abstract class RemoteMessageDataSource {
  Future<List<MessageModel>> getMessages({
    required String page,
    required String limit,
    required String sort,
    required String equipmentId,
  });

  Future<MessageModel> sendMessage({
    required String message,
    required String deviceType,
    required String equipmentId,
    required String categoryId,
  });
}

@LazySingleton(as: RemoteMessageDataSource)
class RemoteMessageDataSourceImpl implements RemoteMessageDataSource {
  final ApiClient client;
  final CookieManager cookieManager;

  RemoteMessageDataSourceImpl(
      {required this.client, required this.cookieManager});

  @override
  Future<List<MessageModel>> getMessages({
    required String page,
    required String limit,
    required String sort,
    required String equipmentId,
  }) async {
    final token = await cookieManager.getToken();

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final headers = {
      'Cookie': 'refresh_token=$token; token=$token',
    };

    final Uri url = Uri.parse(
      '${ApiClient.baseUrl}monitoring/messages?page=$page&limit=$limit&sort=$sort&equipment_id=$equipmentId',
    );

    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final http.StreamedResponse response = await client.send(request);

    if (response.statusCode == 200) {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      final List<dynamic> data = jsonResponse['data'] as List;
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else if (response.statusCode == 400) {
      throw Exception(
          'Messages not found: ${await response.stream.bytesToString()}');
    }

    throw Exception(
        'Failed to fetch messages: ${response.statusCode} ${await response.stream.bytesToString()}');
  }

  @override
  Future<MessageModel> sendMessage({
    required String message,
    required String deviceType,
    required String equipmentId,
    required String categoryId,
  }) async {
    final token = await cookieManager.getToken();

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final headers = {
      'Cookie': 'refresh_token=$token; token=$token',
      'Content-Type': 'application/json',
    };

    final Uri url = Uri.parse('${ApiClient.baseUrl}monitoring/messages');

    final request = http.Request('POST', url);
    request.headers.addAll(headers);
    request.body = jsonEncode({
      'message': message,
      'device_type': deviceType,
      'equipment_id': equipmentId,
      'category_id': categoryId,
    });

    final http.StreamedResponse response = await client.send(request);

    if (response.statusCode == 201) {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      return MessageModel.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      final String responseBody = await response.stream.bytesToString();
      throw Exception('Failed to send message: $responseBody');
    }

    throw Exception(
        'Failed to send message: ${response.statusCode} ${await response.stream.bytesToString()}');
  }
}