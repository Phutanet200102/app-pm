import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../server/service.dart';

void main() {
  runApp(_RecordPage());
}

class _RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: RecordPage(id: 'id'),
    );
  }
}

class RecordPage extends StatefulWidget {
  final String id;
  const RecordPage({Key? key, required this.id}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<_ChartData> chartData = [];
  String selectedInterval = 'In 1 Day';
  int minPm2_5 = 0;
  int maxPm2_5 = 0;
  DateFormat dateFormat = DateFormat.Hms();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchData1();
  }

  Future<void> fetchData1() async {
    try {
      final data = await _apiService.fetchData('data/day', widget.id);
      setState(() {
        chartData = (data['data'] as List)
            .map((item) => _ChartData.fromJson(item))
            .toList();
        dateFormat = DateFormat.H(); // Format to hours
        minPm2_5 = (data['minPm2_5'] as num?)?.toInt() ?? 0;
        maxPm2_5 = (data['maxPm2_5'] as num?)?.toInt() ?? 0;
      });
    } catch (error) {
      print('Error fetching data for 1 Day: $error');
    }
  }

  Future<void> fetchData2() async {
    try {
      final data = await _apiService.fetchData('data/month', widget.id);
      setState(() {
        chartData = (data['data'] as List)
            .map((item) => _ChartData.fromJson(item))
            .toList();
        dateFormat = DateFormat.H(); // Format to hours
        minPm2_5 = (data['minPm2_5'] as num?)?.toInt() ?? 0;
        maxPm2_5 = (data['maxPm2_5'] as num?)?.toInt() ?? 0;
      });
    } catch (error) {
      print('Error fetching data for 1 Day: $error');
    }
  }

  Future<void> fetchData3() async {
    try {
      final data = await _apiService.fetchData('data/year', widget.id);
      setState(() {
        chartData = (data['data'] as List)
            .map((item) => _ChartData.fromJson(item))
            .toList();
        dateFormat = DateFormat.H(); // Format to hours
        minPm2_5 = (data['minPm2_5'] as num?)?.toInt() ?? 0;
        maxPm2_5 = (data['maxPm2_5'] as num?)?.toInt() ?? 0;
      });
    } catch (error) {
      print('Error fetching data for 1 Day: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedInterval,
              items: <String>[
                'In 1 Day',
                'In 1 Month',
                'In 1 Year',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedInterval = newValue!;
                  if (selectedInterval == 'In 1 Day') {
                    fetchData1();
                  } else if (selectedInterval == 'In 1 Month') {
                    fetchData2();
                  } else if (selectedInterval == 'In 1 Year') {
                    fetchData3();
                  }
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            chartData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 400,
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        dateFormat: dateFormat,
                      ),
                      title: ChartTitle(
                          text: 'Temperature, PM2.5, and Humidity Analysis'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries>[
                        LineSeries<_ChartData, DateTime>(
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) =>
                                data.temperature,
                            name: 'Temperature',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true)),
                        LineSeries<_ChartData, DateTime>(
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.pm2_5,
                            name: 'PM2.5',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true)),
                        LineSeries<_ChartData, DateTime>(
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.humidity,
                            name: 'Humidity',
                            color: Colors.green,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true)),
                      ],
                    ),
                  ),
            SizedBox(height: 20),
            Text(
              'Min PM2.5: $minPm2_5, Max PM2_5: $maxPm2_5',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.temperature, this.pm2_5, this.humidity);

  final DateTime date;
  final double temperature;
  final double pm2_5;
  final double humidity;

  factory _ChartData.fromJson(Map<String, dynamic> json) {
    return _ChartData(
      DateTime.parse(json['date']),
      (json['temperature'] as num).toDouble(),
      (json['pm2_5'] as num).toDouble(),
      (json['humidity'] as num).toDouble(),
    );
  }
}
