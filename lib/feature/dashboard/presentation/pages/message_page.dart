import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mining_app/core/storage/cookie_manager.dart';

import '../../../../core/di/injection.dart';
import '../bloc/message/message_bloc.dart';
import '../bloc/message/message_event.dart';
import '../bloc/message/message_state.dart';
import '../bloc/subject/subject_bloc.dart';
import '../bloc/subject/subject_event.dart';
import '../bloc/subject/subject_state.dart';
import 'message_bubble.dart';

class MessagePage extends StatefulWidget {
  final VoidCallback closeThisPage;

  const MessagePage({Key? key, required this.closeThisPage}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final CookieManager _cookieManager = sl<CookieManager>();
  late MessageBloc _messageBloc;
  late SubjectBloc _subjectBloc;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _currentUserNik = "";

  @override
  void initState() {
    super.initState();
    _messageBloc = sl<MessageBloc>()
      ..add(const FetchMessages(
        page: '1',
        limit: '10',
        sort: 'created_at,asc',
        equipmentId: 'cc3df50b55',
      ));
    _subjectBloc = sl<SubjectBloc>()..add(FetchSubjects());
    _cookieManager.getNik().then((nik) {
      setState(() {
        _currentUserNik = nik ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _messageBloc),
        BlocProvider.value(value: _subjectBloc),
      ],
      child: Scaffold(
        backgroundColor: Color(0xFF2E2E35),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('images/ic_message.png',
                              width: 30, height: 30),
                          const SizedBox(width: 8),
                          Text(
                            "Messages",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: widget.closeThisPage,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Text(
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
                    child: BlocBuilder<MessageBloc, MessageState>(
                      builder: (context, messageState) {
                        if (messageState is MessageLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (messageState is MessageLoaded) {
                          final messages = messageState.messages.toList();
                          if (messages.isEmpty) {
                            return Center(
                              child: Text(
                                'No messages found',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          }
                          return ListView.builder(
                              padding: EdgeInsets.only(bottom: 180),
                              itemCount: messages.length,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
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
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Color(0xFF2E2E35),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 120,
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Icon(Icons.search,
                                  color: Colors.grey, size: 18),
                              contentPadding: EdgeInsets.only(left: 8),
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
                        SizedBox(width: 8),
                        Expanded(
                          child: BlocBuilder<SubjectBloc, SubjectState>(
                            builder: (context, subjectState) {
                              if (subjectState is SubjectLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (subjectState is SubjectLoaded) {
                                final templates = subjectState.subjects
                                    .where((subject) =>
                                subject.isActive &&
                                    subject.isForOperator &&
                                    subject
                                        .templateMessageOperator.isNotEmpty)
                                    .map((subject) =>
                                subject.templateMessageOperator)
                                    .toList();

                                final filteredTemplates = templates
                                    .where((template) => template
                                    .toLowerCase()
                                    .contains(_searchQuery))
                                    .toList();

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: filteredTemplates
                                        .map((template) =>
                                        _buildCategoryButton(template))
                                        .toList(),
                                  ),
                                );
                              } else if (subjectState is SubjectError) {
                                return Center(
                                  child: Text(
                                    subjectState.message,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                  color: Color(0xFF9E9E9E), fontSize: 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF1073FC),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Image.asset(
                              'images/ic_send.png',
                              width: 24,
                              height: 24,
                            ),
                            label: Text(
                              "Send",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: 60,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Color(0xFF1073FC),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'images/ic_mic.png',
                              width: 24,
                              height: 24,
                            ),
                            padding: EdgeInsets.all(15),
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
    );
  }

  Widget _buildCategoryButton(String label) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1073FC),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageBloc.close();
    _subjectBloc.close();
    super.dispose();
  }
}