import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/utils.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_event.dart';
import '../bloc/device_state.dart';
import '../../../login/presentation/pages/login_page.dart';

class InstallationPage extends StatefulWidget {
  @override
  _InstallationPageState createState() => _InstallationPageState();
}

class _InstallationPageState extends State<InstallationPage>
    with SingleTickerProviderStateMixin {
  String? deviceId;
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _loadDeviceId();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadDeviceId() async {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (deviceId == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<DeviceBloc>()..add(CheckDeviceStatusEvent(deviceId.toString())),
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/download.png', width: 40, height: 40),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Installation Wizard',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Device must be registered before it can be used',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Your serial number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 300,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFAFDFD)),
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFFD0D7DE),
                    ),
                    child: Text(
                      deviceId.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF646464),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<DeviceBloc, DeviceState>(
                    builder: (context, state) {
                      if (state is DeviceLoading) {
                        _controller.reset();
                        _controller.forward();
                        return Column(
                          children: [
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return LinearProgressIndicator(
                                  value: _progressAnimation.value,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                                );
                              },
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Please wait',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      } else if (state is DeviceWaitingActivation) {
                        return Column(
                          children: [
                            Text(
                              'Waiting for activation...',
                              style: TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                            SizedBox(height: 5),
                          ],
                        );
                      } else if (state is DeviceError) {
                        return Text(
                          state.message,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  Spacer(),
                  Text(
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