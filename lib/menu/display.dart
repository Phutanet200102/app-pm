import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_notification_app_demo/home.dart';
import 'package:local_notification_app_demo/menu/record.dart';
import 'package:local_notification_app_demo/notifi_service.dart';

import '../server/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const DisplayPage());
}

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key}) : super(key: key);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<Map<String, dynamic>> _userMachines = [];
  late NotificationService _notificationService;
  final box = GetStorage();
  late String userId;
  Timer? _timer;
  final ApiService _serverService = ApiService();

  Future<void> _fetchselect() async {
    final userMachines = await _serverService.fetchUserMachines(userId);
    setState(() {
      _userMachines = userMachines;
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.initNotification();
    userId = box.read('userId') ?? '';
    _fetchselect();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _fetchselect());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await _fetchselect();
  }

  Color _getPm25Color(double pm25) {
    if (pm25 >= 0 && pm25 <= 25) {
      return Colors.blue;
    } else if (pm25 >= 26 && pm25 <= 37) {
      return Colors.green;
    } else if (pm25 >= 38 && pm25 <= 50) {
      return Colors.yellow;
    } else if (pm25 >= 51 && pm25 <= 90) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Display',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Display', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            itemCount: _userMachines.length,
            itemBuilder: (context, index) {
              final userMachine = _userMachines[index];
              final data = userMachine['data'];

              if (data == null) {
                return SizedBox.shrink();
              }

              final pm25 = (data['pm2_5'] ?? 0.0).toDouble();
              final notificationColor = _getPm25Color(pm25);

              if (notificationColor == Colors.yellow) {
                _notificationService.showNotification(
                  id: index,
                  title: 'PM2.5 Alert',
                  body: 'PM2.5 level is yellow at ${pm25} µg/m³',
                );
              } else if (notificationColor == Colors.orange) {
                _notificationService.showNotification(
                  id: index,
                  title: 'PM2.5 Alert',
                  body: 'PM2.5 level is orange at ${pm25} µg/m³',
                );
              } else if (notificationColor == Colors.red) {
                _notificationService.showNotification(
                  id: index,
                  title: 'PM2.5 Alert',
                  body: 'PM2.5 level is red at ${pm25} µg/m³',
                );
              }

              return Card(
                child: ListTile(
                  title: Row(
                    children: [
                      Text('Place: ${userMachine['control']['place']}'),
                      SizedBox(width: 5),
                      Icon(Icons.notifications_active,
                          color: notificationColor),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.cloud),
                      SizedBox(width: 5),
                      Text('${pm25} µg/m³'),
                      Icon(Icons.thermostat),
                      SizedBox(width: 5),
                      Text('${data['temperature']} ºC'),
                      Icon(Icons.opacity),
                      SizedBox(width: 5),
                      Text('${data['humidity']} %'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_circle_right_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordPage(
                            id: userMachine['control']['id_user_machine'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
