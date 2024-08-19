import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_notification_app_demo/home.dart';

import '../server/service.dart';

void main() async {
  await GetStorage.init();
  runApp(const ConnectionPage());
}

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final box = GetStorage();
  String _scanBarcode = '';
  TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> _userMachines = [];
  late String userId;
  final ApiService _serverService = ApiService();

  @override
  void initState() {
    super.initState();
    userId = box.read('userId') ?? '';
    _fetchSelect();
  }

  Future<void> _fetchSelect() async {
    final userMachines = await _serverService.fetchUserMachines(userId);
    setState(() {
      _userMachines = userMachines;
    });
  }

  Future<void> _onRefresh() async {
    await _fetchSelect();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    _showNameDialog();
  }

  Future<void> _showNameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Room Location'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Place"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                _fetchInsert();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchInsert() async {
    try {
      await _serverService.insertUserMachine(
          userId, _scanBarcode, nameController.text);
      _fetchSelect();
    } catch (error) {
      print('Error registering user machine: $error');
    }
    nameController.clear();
    _scanBarcode = '';
  }

  Future<void> _fetchUpdate(String id, String time, String id_user_machine,
      String status, String date) async {
    await _serverService.updateUserMachine(
        id, id_user_machine, nameController.text, status, time, date);
    _fetchSelect();
  }

  Future<void> _fetchDelect(String id, String ids) async {
    await _serverService.deleteUserMachine(id, ids);
    _fetchSelect();
  }

  Future<void> _showDialog(String id, String name, String id_user_machine,
      int status, int times, String date) async {
    List<String> places = ['1', '5', '10'];
    int num = times == 1 ? 0 : (times == 5 ? 1 : 2);
    String selectedPlace = places[num];
    nameController.text = name;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Room Location'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedPlace,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPlace = newValue!;
                      });
                    },
                    items: places.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('$value minutes'),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "Place"),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _fetchUpdate(id, selectedPlace, id_user_machine,
                        status.toString(), date);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
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
          title: Text('Connection', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: scanQR,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: _userMachines.length,
            itemBuilder: (context, index) {
              final userMachine = _userMachines[index];
              return Card(
                child: ListTile(
                  title: Text('Place: ${userMachine['control']['place']}'),
                  subtitle: Text('Time: ${userMachine['control']['time']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showDialog(
                            userMachine['control']['id'],
                            userMachine['control']['place'],
                            userMachine['control']['id_user_machine'],
                            userMachine['control']['status'],
                            userMachine['control']['time'],
                            userMachine['control']['date'],
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _fetchDelect(
                              userMachine['control']['id_user_machine'],
                              userMachine['control']['id']);
                        },
                      ),
                    ],
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
