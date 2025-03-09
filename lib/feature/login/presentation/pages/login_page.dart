import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mining_app/core/network/api_client.dart';
import 'package:mining_app/feature/dashboard/presentation/pages/dashboard_page.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/login_responses.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nikController = TextEditingController();
  final _unitId = ApiClient.unitId;
  final _shiftId = '048C-DS';
  final _loginType = 1;

  @override
  void dispose() {
    _nikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginSuccess) {
              return _buildWelcomeScreen(context, state.user);
            }
            return _buildLoginScreen(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context, LoginState state) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login by Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter your NIK',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nikController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter NIK',
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            if (state is LoginFailure)
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Can't find your NIK",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                if (_nikController.text.isNotEmpty) {
                  context.read<LoginBloc>().add(LoginSubmitted(
                    unitId: _unitId,
                    nik: _nikController.text,
                    shiftId: _shiftId,
                    loginType: _loginType,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter NIK')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: state is LoginLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context, LoginResponse user) {
    return Center(
      child: Container(
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.blue,
                width: double.infinity,
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 70),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardPage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: user.imageUrl != null
                        ? NetworkImage(user.imageUrl!)
                        : AssetImage('assets/default_avatar.jpg') as ImageProvider,
                    child: user.imageUrl == null
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        user.roleName ?? 'Unknown Role',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}