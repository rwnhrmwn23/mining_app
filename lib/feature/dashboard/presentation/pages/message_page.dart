import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/subject_bloc.dart';
import '../bloc/subject_event.dart';
import '../bloc/subject_state.dart';

class MessagePage extends StatefulWidget {
  final VoidCallback closeThisPage;

  const MessagePage({Key? key, required this.closeThisPage}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late SubjectBloc _subjectBloc;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _subjectBloc = sl<SubjectBloc>()..add(FetchSubjects());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _subjectBloc,
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFC99D00),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'RAHMAT (45678)',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Proses Blasting sedang berlangsung pastikan Anda berada pada area aman',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 4),
                        Text('23 Nov 2024, 12:00',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(child: SizedBox()),
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
                            builder: (context, state) {
                              if (state is SubjectLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is SubjectLoaded) {
                                final templates = state.subjects
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
                              } else if (state is SubjectError) {
                                return Center(
                                  child: Text(state.message,
                                      style: TextStyle(color: Colors.red)),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
    _subjectBloc.close();
    super.dispose();
  }
}
