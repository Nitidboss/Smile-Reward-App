class Reward {
  final String id; // รหัสของรางวัล
  final String name; // ชื่อรางวัล
  final String description; // รายละเอียดรางวัล
  final int points; // คะแนนที่ต้องใช้ในการแลกรางวัล
  final String imageUrl; // URL รูปภาพของรางวัล
  bool isSaved; // สถานะการบันทึกรายการโปรด (เปลี่ยนแปลงได้)

  /// สร้างออบเจ็กต์รางวัลใหม่
  /// [isSaved] จะมีค่าเริ่มต้นเป็น false (ยังไม่ได้บันทึกเป็นรายการโปรด)
  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.imageUrl,
    this.isSaved = false, // ค่าเริ่มต้น: ยังไม่ได้บันทึกเป็นรายการโปรด
  });
}
