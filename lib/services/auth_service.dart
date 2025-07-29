import '../models/user.dart';

class AuthService {
  static const String validEmail = 'smile@smilefokus.com';
  static const String validPassword = '11111111';

  // ข้อมูลผู้ใช้ปัจจุบันที่ล็อกอินอยู่ (null = ยังไม่ได้ล็อกอิน)
  static User? currentUser;

  /// ตรวจสอบรูปแบบอีเมลว่าถูกต้องหรือไม่
  /// ใช้ Regular Expression ตรวจสอบรูปแบบ text@text.text
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  /// ตรวจสอบความยาวรหัสผ่านว่าเพียงพอหรือไม่
  /// ต้องมีอย่างน้อย 8 ตัวอักษร
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  /// สร้างออบเจ็กต์ผู้ใช้หากข้อมูลถูกต้อง
  /// คืนค่า true หากสำเร็จ, false หากล้มเหลว
  static bool login(String email, String password) {
    if (email == validEmail && password == validPassword) {
      // สร้างผู้ใช้ใหม่พร้อมคะแนนเริ่มต้น
      currentUser = User(
        email: email,
        firstName: 'smile',
        lastName: 'Challenge',
        points: 10000,
      );
      return true;
    }
    return false;
  }

  /// ล็อกเอาต์ผู้ใช้ปัจจุบัน
  /// ลบข้อมูลผู้ใช้ออกจากหน่วยความจำ
  static void logout() {
    currentUser = null;
  }

  /// ตรวจสอบว่าผู้ใช้ล็อกอินอยู่หรือไม่
  /// คืนค่า true หากมีผู้ใช้ล็อกอินอยู่
  static bool isLoggedIn() {
    return currentUser != null;
  }
}
