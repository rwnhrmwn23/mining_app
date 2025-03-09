import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mining_app/core/storage/cookie_manager.dart';
import 'package:centrifuge/centrifuge.dart' as centrifuge;

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../bloc/message/message_bloc.dart';
import '../bloc/message/message_event.dart';
import '../bloc/message/message_state.dart';
import '../bloc/subject/subject_bloc.dart';
import '../bloc/subject/subject_event.dart';
import '../bloc/subject/subject_state.dart';
import 'message_bubble.dart';
import '../../domain/entities/message.dart';
import '../../data/models/message_model.dart';

class MessagePage extends StatefulWidget {
  final VoidCallback closeThisPage;

  const MessagePage({Key? key, required this.closeThisPage}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final CookieManager _cookieManager = sl<CookieManager>();
  final ScrollController _scrollController = ScrollController();
  late MessageBloc _messageBloc;
  late SubjectBloc _subjectBloc;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _searchQuery = "";
  String _currentUserNik = "";

  late centrifuge.Client client;
  late centrifuge.Subscription subscription;
  final String unitId = ApiClient.unitId;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _messageBloc = sl<MessageBloc>()
      ..add(
        const FetchMessages(
          page: '1',
          limit: '100',
          sort: 'created_at,asc',
          equipmentId: ApiClient.unitId,
        ),
      );
    _subjectBloc = sl<SubjectBloc>()..add(FetchSubjects());
    _cookieManager.getNik().then((nik) {
      setState(() {
        _currentUserNik = nik ?? "";
      });
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      _messageBloc.add(
        SendingMessage(
          message: text.trim(),
          equipmentId: ApiClient.unitId,
          deviceType: 'Mobile',
          categoryId: '1',
        ),
      );
      _messageController.clear();
    }
  }

  void _initializeWebSocket() async {
    try {
      client = centrifuge.createClient(ApiClient.baseUrlWS);

      client.connectStream.listen((event) {
        print('WebSocket => Connected: ${event.client}, ${event.data}');
        _subscribeToChannel();
      });

      client.errorStream.listen((event) {
        print('WebSocket => Error: ${event.error}');
      });

      client.disconnectStream.listen((event) {
        print('WebSocket => Disconnected: ${event.reason}, shouldReconnect: ${event.shouldReconnect}');
        if (event.shouldReconnect) {
          _subscribeToChannel();
        }
      });

      client.publishStream.listen((event) {
        print('WebSocket => New message received on channel ${event.channel}: ${event.data}');
        if (event.channel == '${ApiClient.channelPrefix}/monitoring/messages/equipments/$unitId') {
          _handleNewMessage(event.data);
        }
      });

      print('WebSocket => Connecting to ${ApiClient.baseUrlWS}...');
      await client.connect();
    } catch (e) {
      print('WebSocket => Failed to initialize WebSocket: $e');
    }
  }

  void _subscribeToChannel() {
    try {
      final channel = '${ApiClient.channelPrefix}/monitoring/messages/equipments/$unitId';
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

      final newMessage = MessageModel.fromJson(jsonData);
      final currentState = _messageBloc.state;
      if (currentState is MessageLoaded) {
        final updatedMessages = List<Message>.from(currentState.messages)..add(newMessage);
        _messageBloc.add(UpdateMessages(updatedMessages));
      } else {
        _messageBloc.add(UpdateMessages([newMessage]));
      }
    } catch (e) {
      print('WebSocket => Error processing message: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _messageBloc.close();
    _subjectBloc.close();
    _scrollController.dispose();
    subscription.unsubscribe();
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _messageBloc),
        BlocProvider.value(value: _subjectBloc),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFF2E2E35),
          body: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('images/ic_message.png', width: 30, height: 30),
                            const SizedBox(width: 8),
                            const Text(
                              "Messages",
                              style: TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: widget.closeThisPage,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(color: Colors.black),
                            child: const Text(
                              'Back',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocListener<MessageBloc, MessageState>(
                        listener: (context, state) {
                          if (state is MessageLoaded) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                          }
                        },
                        child: BlocBuilder<MessageBloc, MessageState>(
                          builder: (context, messageState) {
                            if (messageState is MessageLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (messageState is MessageLoaded) {
                              final messages = messageState.messages.toList();
                              if (messages.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No messages found',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              }
                              return ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(bottom: 180),
                                itemCount: messages.length,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final message = messages[index];
                                  return MessageBubble(
                                    senderName: message.senderName,
                                    senderNik: message.senderNik,
                                    message: message.message,
                                    createdAt: message.createdAt.toIso8601String(),
                                    currentUserNik: _currentUserNik,
                                  );
                                },
                              );
                            } else if (messageState is MessageError) {
                              return Center(
                                child: Text(
                                  messageState.message,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFF2E2E35),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: const Icon(Icons.search, color: Colors.grey, size: 18),
                                contentPadding: const EdgeInsets.only(left: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.toLowerCase();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: BlocBuilder<SubjectBloc, SubjectState>(
                              builder: (context, subjectState) {
                                if (subjectState is SubjectLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (subjectState is SubjectLoaded) {
                                  final templates = subjectState.subjects
                                      .where((subject) =>
                                  subject.isActive &&
                                      subject.isForOperator &&
                                      subject.templateMessageOperator.isNotEmpty)
                                      .map((subject) => subject.templateMessageOperator)
                                      .toList();

                                  final filteredTemplates = templates
                                      .where((template) => template.toLowerCase().contains(_searchQuery))
                                      .toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: filteredTemplates
                                          .map((template) => _buildCategoryButton(template))
                                          .toList(),
                                    ),
                                  );
                                } else if (subjectState is SubjectError) {
                                  return Center(
                                    child: Text(
                                      subjectState.message,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _sendMessage(_messageController.text),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1073FC),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('images/ic_send.png', width: 24, height: 24),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Send",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 60,
                            width: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1073FC),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset('images/ic_mic.png', width: 24, height: 24),
                              padding: const EdgeInsets.all(15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => _sendMessage(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1073FC),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}