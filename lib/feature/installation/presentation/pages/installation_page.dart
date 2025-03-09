import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/utils.dart';
import '../../../login/presentation/pages/login_page.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_event.dart';
import '../bloc/device_state.dart';
import 'package:centrifuge/centrifuge.dart' as centrifuge;

class InstallationPage extends StatefulWidget {
  @override
  _InstallationPageState createState() => _InstallationPageState();
}

class _InstallationPageState extends State<InstallationPage> {
  String? deviceId;
  double _progressValue = 0.0;
  bool _showProgressBar = true;

  late centrifuge.Client client;
  late centrifuge.Subscription subscription;
  final String unitId = ApiClient.unitId;


  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  void _initializeWebSocket() async {
    try {
      client = centrifuge.createClient(ApiClient.baseUrlWS);

      updateProgress(0.6);
      print('WebSocket => Connecting to ${ApiClient.baseUrlWS}...');

      client.connectStream.listen((event) {
        print('WebSocket => Connected: ${event.client}, ${event.data}');
        updateProgress(0.8);
        _subscribeToChannel();
      });

      client.errorStream.listen((event) {
        print('WebSocket => Error: ${event.error}');
      });

      client.disconnectStream.listen((event) {
        print(
            'WebSocket => Disconnected: ${event.reason}, shouldReconnect: ${event.shouldReconnect}');
        if (event.shouldReconnect) {
          _subscribeToChannel();
        }
      });

      client.publishStream.listen((event) {
        print(
            'WebSocket => New message received on channel ${event.channel}: ${event.data}');
        _handleNewMessage(event.data);
      });

      await client.connect();
    } catch (e) {
      print('WebSocket => Failed to initialize WebSocket: $e');
    }
  }

  void _subscribeToChannel() {
    try {
      final channel = '${ApiClient.channelPrefix}/equipments/devices/$deviceId/activated';
      print('WebSocket => Subscribing to channel: $channel');

      subscription = client.getSubscription(channel);

      subscription.subscribeSuccessStream.listen((event) {
        print('WebSocket => Subscribed to channel: $channel');
        updateProgress(1.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      });

      subscription.unsubscribeStream.listen((event) {
        print('WebSocket => Unsubscribed from channel: $channel');
      });

      subscription.publishStream.listen((event) {
        print('WebSocket => New publication on channel data: ${event.data}');
        _handleNewMessage(event.data);
      });

      subscription.subscribe();
    } catch (e) {
      print('WebSocket => Failed to subscribe: $e');
    }
  }

  void _handleNewMessage(List<int> data) {
    print('WebSocket => Raw data received: $data');
    try {
      final rawString = utf8.decode(data);
      print('WebSocket => Decoded string: $rawString');

      final jsonData = jsonDecode(rawString) as Map<String, dynamic>;
      print('WebSocket => Parsed JSON: $jsonData');
    } catch (e) {
      print('WebSocket => Error processing message: $e');
    }
  }

  Future<void> _loadDeviceId() async {
    updateProgress(0.1);
    final savedDeviceId = await LocalStorage.getDeviceId();
    if (savedDeviceId != null) {
      setState(() {
        deviceId = savedDeviceId;
      });
    } else {
      final newDeviceId = generateDeviceId();
      await LocalStorage.saveDeviceId(newDeviceId);
      setState(() {
        deviceId = newDeviceId;
      });
    }
    print('deviceId: $deviceId');
  }

  void updateProgress(double value) {
    setState(() {
      _progressValue = value.clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    subscription.unsubscribe();
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (deviceId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return BlocProvider(
      create: (_) =>
          sl<DeviceBloc>()..add(CheckDeviceStatusEvent(deviceId.toString())),
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue),
            ),
            child: BlocListener<DeviceBloc, DeviceState>(
              listener: (context, state) {
                if (state is DeviceActive) {
                  _initializeWebSocket();
                } else if (state is DeviceLoading) {
                  updateProgress(0.6);
                } else if (state is DeviceWaitingActivation) {
                  updateProgress(1.0);
                  setState(() {
                    _showProgressBar = false;
                  });
                  updateProgress(1.0);
                } else if (state is DeviceError) {
                  updateProgress(0.0);
                  _showProgressBar = false;
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/download.png', width: 40, height: 40),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Installation Wizard',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            'Device must be registered before it can be used',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Your serial number',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFAFDFD)),
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFFD0D7DE),
                    ),
                    child: Text(
                      deviceId.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF646464)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!_showProgressBar)
                    Column(
                      children: const [
                        Text(
                          'Waiting for activation...',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        SizedBox(height: 5),
                      ],
                    )
                  else
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _progressValue == 0.0
                              ? 'Waiting...'
                              : '${(_progressValue * 100).toInt()}% Completed',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  const Spacer(),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
