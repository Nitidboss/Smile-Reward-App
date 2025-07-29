import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const SmileRewardApp());
}

class SmileRewardApp extends StatelessWidget {
  const SmileRewardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smile Reward App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      // ตรวจสอบสถานะการล็อกอินเพื่อกำหนดหน้าเริ่มต้น
      home: AuthService.isLoggedIn()
          ? const HomePage() // หากล็อกอินแล้ว -> ไปหน้าหลัก
          : const LoginPage(), // หากยังไม่ล็อกอิน -> ไปหน้าล็อกอิน
      debugShowCheckedModeBanner: false, // ซ่อนแบนเนอร์ DEBUG ในมุมขวาบน
    );
  }
}
