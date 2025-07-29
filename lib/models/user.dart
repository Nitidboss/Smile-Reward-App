class User {
  final String email; // อีเมลของผู้ใช้
  final String firstName; // ชื่อจริง
  final String lastName; // นามสกุล
  int points; // คะแนนสะสม
  
  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.points,
  });

  /// Getter สำหรับดึงชื่อเต็มของผู้ใช้
  /// รวมชื่อจริงและนามสกุลเข้าด้วยกัน
  String get fullName => '$firstName $lastName';
}
