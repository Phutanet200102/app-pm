import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/home.dart';

void main() {
  runApp(MaterialApp(
    home: BookPage(),
  ));
}

class BookPage extends StatelessWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Book', style: TextStyle(color: Colors.white)),
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
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'คู่มือการใช้งาน',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '1. Control',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '  - สามารถสั่งเปิด/ปิดการทำการของอุปกรณ์ได้',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '2. Connection',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      ' - เริ่มจากจิ้มไปที่ Icon เพิ่ม เพื่อทำการเพิ่มอุปกรณ์ของเรา\n  - จากนั้นจะมีอุปกรณ์เพิ่มขึ้นมา\n  - อุปกรณ์ที่เพิ่มเข้ามาสามารถแก้ไขสถานที่ได้\n  - สามารถลบอุปกรณ์ได้',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '3. Display',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '  - แสดงสถานทีตั้งอุปกรณ์\n  - แสดง PM2.5\n  - แสดง อุณหภูมิ\n  - แสดงความชื้น\n',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '   - PM2.5 History',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '  - แสดงกราฟ ตามเวลาที่เรากำหนด\n  - สามารถทำข้อมูลไปวิเคราะห์ต่อได้',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ค่าฝุ่น PM2.5 ปริมาณเท่าไร อันตรายอย่างไร',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '   สีฟ้า: ค่าฝุ่น PM 2.5 อยู่ที่ 0-25 มคก./ลบ.ม. คุณภาพอากาศอยู่ในระดับดีมาก เหมาะสำหรับกิจกรรมกลางแจ้งและการท่องเที่ยว',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '   สีเขียว: 26-37 มคก./ลบ.ม. คุณภาพอากาศระดับดี สามารถทำกิจกรรมกลางแจ้งและการท่องเที่ยวได้ตามปกติ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '   สีเหลือง: 38-50 มคก./ลบ.ม. คุณภาพอากาศระดับปานกลาง ประชาชนทั่วไปสามารถทำกิจกรรมกลางแจ้งได้ตามปกติ ส่วนผู้ที่ต้องดูแลสุขภาพเป็นพิเศษ หากมีอาการเบื้องต้น เช่น ไอ หายใจลำบาก ระคายเคืองตา ควรลดระยะเวลาการทำกิจกรรมกลางแจ้ง',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '   สีส้ม: 51-90 มคก./ลบ.ม. คุณภาพอากาศเริ่มมีผลกระทบต่อสุขภาพ ประชาชนทั่วไป ควรเฝ้าระวังสุขภาพ ถ้ามีอาการเบื้องต้น เช่น ไอ หายใจลำบาก ระคายเคืองตา ควรลดระยะเวลาการทำกิจกรรมกลางแจ้ง หรือใช้อุปกรณ์ป้องกันตนเองหากมีความจำเป็น ส่วนผู้ที่ต้องดูแลสุขภาพเป็นพิเศษ ควรลดระยะเวลาการทำกิจกรรมกลางแจ้ง หรือใช้อุปกรณ์ป้องกันตนเองหากมีความจำเป็น ถ้ามีอาการทางสุขภาพ เช่น ไอ หายใจลำบาก ตาอักเสบ แน่นหน้าอก ปวดศีรษะ หัวใจเต้นไม่เป็นปกติ คลื่นไส้ อ่อนเพลีย ควรปรึกษาแพทย์',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '   สีแดง: ค่าฝุ่น PM 2.5 ตั้งแต่ 91 มคก./ลบ.ม.ขึ้นไป คุณภาพอากาศอยู่ในระดับที่มีผลกระทบต่อสุขภาพ ทุกคนควรหลีกเลี่ยงกิจกรรมกลางแจ้ง หลีกเลี่ยงพื้นที่ที่มีมลพิษทางอากาศสูง หรือใช้อุปกรณ์ป้องกันตนเองหากมีความจำเป็น และหากมีอาการทางสุขภาพควรปรึกษาแพทย์',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}