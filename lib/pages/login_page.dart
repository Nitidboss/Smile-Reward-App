import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

/// หน้าล็อกอินที่จัดการการยืนยันตัวตนของผู้ใช้
/// แสดงฟอร์มอีเมล/รหัสผ่าน พร้อมการตรวจสอบความถูกต้องและจัดการข้อผิดพลาด
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // คีย์สำหรับการตรวจสอบความถูกต้องของฟอร์ม
  final _formKey = GlobalKey<FormState>();

  // ตัวควบคุมช่องกรอกข้อมูล - จัดการข้อมูลที่ผู้ใช้กรอก
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // สถานะข้อความแจ้งข้อผิดพลาด - null หมายถึงไม่มีข้อผิดพลาดให้แสดง
  String? _emailError; // ข้อความแจ้งข้อผิดพลาดการตรวจสอบอีเมล
  String? _passwordError; // ข้อความแจ้งข้อผิดพลาดการตรวจสอบรหัสผ่าน
  String? _generalError; // ข้อความแจ้งข้อผิดพลาดการพยายามล็อกอิน

  @override
  void dispose() {
    // ทำความสะอาดตัวควบคุมเพื่อป้องกันการรั่วไหลของหน่วยความจำ
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// จัดการกระบวนการล็อกอินพร้อมการตรวจสอบและยืนยันตัวตน
  /// ตรวจสอบช่องกรอกข้อมูล, ตรวจสอบข้อมูลรับรอง, และนำทางเมื่อสำเร็จ
  void _login() {
    // ล้างข้อความแจ้งข้อผิดพลาดก่อนหน้าก่อนการตรวจสอบใหม่
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    // ดึงค่าข้อมูลที่กรอกโดยตัดช่องว่างออก
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool hasValidationErrors = false;

    // ตรวจสอบช่องอีเมล - ตรวจสอบว่างก่อน จากนั้นตรวจสอบรูปแบบ
    if (email.isEmpty) {
      setState(() {
        _emailError = 'กรุณากรอกอีเมล';
      });
      hasValidationErrors = true;
    } else if (!AuthService.isValidEmail(email)) {
      // ตรวจสอบรูปแบบอีเมลก็ต่อเมื่อช่องไม่ว่าง
      setState(() {
        _emailError = 'รูปแบบอีเมลไม่ถูกต้อง';
      });
      hasValidationErrors = true;
    }

    // ตรวจสอบช่องรหัสผ่าน - ตรวจสอบว่างก่อน จากนั้นตรวจสอบความยาว
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'กรุณากรอกรหัสผ่าน';
      });
      hasValidationErrors = true;
    } else if (password.length < 8) {
      setState(() {
        _passwordError = 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
      });
      hasValidationErrors = true;
    }

    // หยุดการทำงานหากมีข้อผิดพลาดในการตรวจสอบ
    if (hasValidationErrors) {
      return;
    }

    // พยายามยืนยันตัวตนด้วยข้อมูลรับรองที่ให้มา
    bool isLoginSuccessful = AuthService.login(email, password);

    if (isLoginSuccessful) {
      // นำทางไปหน้าหลักและลบหน้าล็อกอินออกจากสแต็ก
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // แสดงข้อความแจ้งข้อผิดพลาดการยืนยันตัวตน
      setState(() {
        _generalError = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // ซ่อนปุ่มกลับ
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                const Text(
                  'smileReward',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // ช่องกรอกอีเมล
                TextFormField(
                  controller: _emailController,
                  keyboardType:
                      TextInputType.emailAddress, // แป้นพิมพ์สำหรับอีเมล
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                // คอนเทนเนอร์ความสูงคงที่สำหรับข้อผิดพลาดอีเมล
                SizedBox(
                  height: 24,
                  child: _emailError != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _emailError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(
                  height: 5,
                ),
                // ช่องกรอกรหัสผ่าน
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // ซ่อนรหัสผ่าน
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                // คอนเทนเนอร์ความสูงคงที่สำหรับข้อผิดพลาดรหัสผ่าน
                SizedBox(
                  height: 24,
                  child: _passwordError != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _passwordError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 24),

                // ปุ่มล็อกอิน
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // คอนเทนเนอร์ความสูงคงที่สำหรับข้อผิดพลาดทั่วไป
                SizedBox(
                  height: 40,
                  child: _generalError != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _generalError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
