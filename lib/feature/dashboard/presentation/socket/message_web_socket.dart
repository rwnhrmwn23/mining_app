import 'dart:convert';
import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:injectable/injectable.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> data);

@lazySingleton
class MessageWebSocket {
  late centrifuge.Client _client;
  late centrifuge.Subscription _subscription;
  final String baseUrl = 'wss://wss.apps-madhani.com/connection/websocket';
  final String channelPrefix = 'ws/fms-dev';

  MessageWebSocket();

  /// Initialize WebSocket connection
  void initialize({required String unitId, required OnMessageReceived onMessageReceived}) async {
    try {
      _client = centrifuge.createClient(baseUrl);

      _client.connectStream.listen((event) {
        _subscribeToChannel(unitId, onMessageReceived);
      });

      _client.disconnectStream.listen((event) {
        if (event.shouldReconnect) {
          _subscribeToChannel(unitId, onMessageReceived);
        }
      });

      _client.publishStream.listen((event) {
        _handleNewMessage(event.data, onMessageReceived);
      });

      await _client.connect();
    } catch (e) {
      print('WebSocket => Failed to initialize: $e');
    }
  }

  /// Subscribe to WebSocket channel
  void _subscribeToChannel(String unitId, OnMessageReceived onMessageReceived) {
    try {
      final channel = '$channelPrefix/monitoring/messages/equipments/$unitId';
      _subscription = _client.getSubscription(channel);

      _subscription.publishStream.listen((event) {
        _handleNewMessage(event.data, onMessageReceived);
      });

      _subscription.subscribe();
    } catch (e) {
      print('WebSocket => Failed to subscribe: $e');
    }
  }

  /// Handle incoming messages
  void _handleNewMessage(List<int> data, OnMessageReceived onMessageReceived) {
    try {
      final rawString = utf8.decode(data);
      final jsonData = jsonDecode(rawString) as Map<String, dynamic>;
      print('WebSocket => Received message: $jsonData');

      onMessageReceived(jsonData);
    } catch (e) {
      print('WebSocket => Error processing message: $e');
    }
  }

  /// Disconnect WebSocket
  void disconnect() {
    _subscription.unsubscribe();
    _client.disconnect();
  }
}
