import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_notification_app_demo/home.dart';

import '../server/service.dart';

void main() async {
  await GetStorage.init();
  runApp(ControlPage());
}

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  List<Map<String, dynamic>> _userMachines = [];
  final box = GetStorage();
  late String userId;
  late ScrollController _scrollController;
  final ApiService _serverService = ApiService();

  @override
  void initState() {
    super.initState();
    userId = box.read('userId') ?? '';
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchSelect();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchSelect();
    }
  }

  Future<void> _fetchSelect() async {
    final userMachines = await _serverService.fetchUserMachines(userId);
    setState(() {
      _userMachines = userMachines;
    });
  }

  Future<void> _fetchUpdate(String id, String idUserMachine, String place,
      int status, int time) async {
    await _serverService.fetchUpdateStatus(
        id, idUserMachine, place, status, time);
    _fetchSelect();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Control', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _userMachines.length,
            itemBuilder: (context, index) {
              final userMachine = _userMachines[index];
              return Card(
                child: ListTile(
                  title: Text('Place: ${userMachine['control']['place']}'),
                  subtitle: Text(
                      'Status: ${userMachine['control']['status'] == 1 ? 'On' : 'Off'}'),
                  trailing: IconButton(
                    icon: userMachine['control']['status'] == 1
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow),
                    onPressed: () {
                      _fetchUpdate(
                        userMachine['control']['id'],
                        userMachine['control']['id_user_machine'],
                        userMachine['control']['place'],
                        userMachine['control']['status'],
                        userMachine['control']['time'],
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
