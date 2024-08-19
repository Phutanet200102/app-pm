import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_notification_app_demo/main.dart';
import 'package:local_notification_app_demo/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = GetStorage();
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = box.read('userId') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
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
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {
                box.remove('userId');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.orange,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome! , PM 2.5',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MenuPage(num: 0);
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.control_camera, size: 30),
                              SizedBox(height: 8),
                              Text('Control'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MenuPage(num: 1);
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.wifi, size: 30),
                              SizedBox(height: 8),
                              Text('Connection'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MenuPage(num: 2);
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.display_settings, size: 30),
                              SizedBox(height: 8),
                              Text('Display'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MenuPage(num: 3);
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.book, size: 30),
                              SizedBox(height: 8),
                              Text('Book'),
                            ],
                          ),
                        ),
                      ),
                    ],
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
