import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mining_app/feature/dashboard/presentation/pages/message_page.dart';
import 'package:mining_app/feature/dashboard/presentation/pages/popup_message_with_slider.dart';
import 'package:centrifuge/centrifuge.dart' as centrifuge;

import '../../../../core/network/api_client.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool showDetailMessage = false;

  // Web Socket
  late centrifuge.Client client;
  late centrifuge.Subscription subscription;
  final String unitId = ApiClient.unitId;
  final String baseUrl = 'wss://wss.apps-madhani.com/connection/websocket';
  final String channelPrefix = 'ws/fms-dev';

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  @override
  void dispose() {
    subscription.unsubscribe();
    client.disconnect();
    super.dispose();
  }

  void _showDetailMessage() {
    setState(() {
      showDetailMessage = true;
    });
  }

  void _hideDetailMessage() {
    setState(() {
      showDetailMessage = false;
    });
  }

  void _showPopupMessage(
    BuildContext context,
    String name,
    String message,
    String date,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return PopupMessageWithSlider(
          onSlideRight: _showDetailMessage,
          name: name,
          message: message,
          date: date,
        );
      },
    );
  }

  void _initializeWebSocket() async {
    try {
      client = centrifuge.createClient(baseUrl);

      client.connectStream.listen((event) {
        print('WebSocket => Connected: ${event.client}, ${event.data}');
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
        if (event.channel ==
            '$channelPrefix/monitoring/messages/equipments/$unitId') {
          _handleShowNewMessage(event.data);
        }
      });

      print('WebSocket => Connecting to $baseUrl...');
      await client.connect();
    } catch (e) {
      print('WebSocket => Failed to initialize WebSocket: $e');
    }
  }

  void _subscribeToChannel() {
    try {
      final channel = '$channelPrefix/monitoring/messages/equipments/$unitId';
      print('WebSocket => Subscribing to channel: $channel');

      subscription = client.getSubscription(channel);

      subscription.subscribeSuccessStream.listen((event) {
        print('WebSocket => Subscribed to channel: $channel');
      });

      subscription.unsubscribeStream.listen((event) {
        print('WebSocket => Unsubscribed from channel: $channel');
      });

      subscription.publishStream.listen((event) {
        print('WebSocket => New publication on channel data: ${event.data}');
        _handleShowNewMessage(event.data);
      });

      subscription.subscribe();
    } catch (e) {
      print('WebSocket => Failed to subscribe: $e');
    }
  }

  void _handleShowNewMessage(List<int> data) {
    print('WebSocket => Raw data received: $data');
    try {
      final rawString = utf8.decode(data);
      print('WebSocket => Decoded string: $rawString');

      final jsonData = jsonDecode(rawString) as Map<String, dynamic>;
      print('WebSocket => Parsed JSON: $jsonData');

      var senderName = jsonData['sender_name'] != null && jsonData['sender_name'].isNotEmpty
              ? jsonData['sender_name'] : jsonData['sender_nik'];
      var message = jsonData['message'];
      var createdAt = jsonData['created_at'];
      if (jsonData.isNotEmpty && showDetailMessage == false) {
        _showPopupMessage(
          context,
          senderName,
          message,
          createdAt,
        );
      }
    } catch (e) {
      print('WebSocket => Error processing message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background_dashboard.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 80,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 100,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/ic_speed.png',
                                  width: 40, height: 40),
                              SizedBox(height: 8),
                              Text(
                                'Materials',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 100,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '75',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'km/h',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 90,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'MAX',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '70',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'MIN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '35',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 100,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/ic_achievement.png',
                                  width: 40, height: 40),
                              SizedBox(height: 8),
                              Text(
                                'Achievement',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 100,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '100/50 Ton',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: 90,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '50%',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 100,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/ic_coal.png',
                                  width: 40, height: 40),
                              SizedBox(height: 8),
                              Text(
                                'Materials',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 100,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                          ),
                          child: Text(
                            'COALS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 300,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'HAULING',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('images/ic_clock.png', width: 30),
                                  SizedBox(width: 8),
                                  Text(
                                    '02:00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 600,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'DSP-2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 4,
                            color: Colors.blue,
                          ),
                          Image.asset('images/ic_route.png', width: 40),
                          Container(
                            width: 60,
                            height: 4,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset('images/ic_clock.png', width: 30),
                              SizedBox(width: 4),
                              Text(
                                '14m 42s',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '1km To go',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 21),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF7B1B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'END ACTIVITY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _showActivityDialog(context);
                        },
                        child: Text(
                          'ACTIVITY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showDetailMessage)
            Positioned(
              left: 0,
              bottom: 80,
              top: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: MessagePage(
                  closeThisPage: _hideDetailMessage,
                ),
              ),
            ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Text(
                      'EMERGENCY',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.red),
                        child: Text(
                          'BREAKDOWN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.settings, color: Colors.white, size: 45),
                      SizedBox(width: 16),
                      Icon(Icons.insert_chart, color: Colors.white, size: 45),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => {
                          _showDetailMessage()
                        },
                        child: Image.asset('images/ic_messages.png', width: 45),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Image.asset('images/ic_menu.png', width: 60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showActivityDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF2E2E35),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child:
                          Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Choose Activity',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    "IDLE",
                    "HAULING",
                    "LOADING",
                    "HANGING",
                    "DUMPING",
                    "QUEUING",
                    "MAINTENANCE"
                  ].map((activity) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$activity Clicked'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          activity,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}