import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/menu/book.dart';
import 'package:local_notification_app_demo/menu/connection.dart';
import 'package:local_notification_app_demo/menu/control.dart';
import 'package:local_notification_app_demo/menu/display.dart';

class MenuPage extends StatelessWidget {
  final int num;

  MenuPage({required this.num});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: MyHomePage(num: num),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int num;
  MyHomePage({Key? key, required this.num}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _currentIndex;
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.num;
    tabs = [
      ControlPage(),
      ConnectionPage(),
      DisplayPage(),
      BookPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        iconSize: 35,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.control_camera),
              label: 'Control',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              label: 'Connection',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.display_settings),
              label: 'Display',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Book',
              backgroundColor: Colors.orange),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
