import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../services/auth_service.dart';

/// หน้ารายละเอียดรางวัล
/// ตรวจสอบคะแนน แสดงยืนยันการแลก และจัดการการหักคะแนน
class RewardDetailPage extends StatefulWidget {
  final Reward reward; // ข้อมูลรางวัลที่จะแสดงรายละเอียด

  const RewardDetailPage({super.key, required this.reward});

  @override
  State<RewardDetailPage> createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends State<RewardDetailPage> {
  /// สลับสถานะการบันทึกรายการโปรดของรางวัล
  void _toggleSave() {
    setState(() {
      widget.reward.isSaved = !widget.reward.isSaved;
    });
  }

  /// ตรวจสอบคะแนน แสดง Dialog ยืนยัน และหักคะแนนเมื่อยืนยัน
  void _redeemReward() {
    final user = AuthService.currentUser!;

    // ตรวจสอบคะแนนก่อนแลก
    if (user.points < widget.reward.points) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('คะแนนไม่เพียงพอสำหรับการแลกรางวัลนี้'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // แสดง Dialog ยืนยันการแลกรางวัล
    showDialog(
      context: context,
      barrierDismissible: false, // ห้ามปิด Dialog โดยการแตะข้างนอก
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Confirm Reward Redemption',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // ปุ่มยกเลิก
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิด Dialog
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ปุ่มยืนยันการแลก
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // หักคะแนนผู้ใช้
                        user.points -= widget.reward.points;

                        Navigator.of(context).pop(); // ปิด Dialog

                        // แสดงข้อความแจ้งการแลกสำเร็จ
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'แลกรางวัล "${widget.reward.name}" สำเร็จ!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // กลับไปหน้าก่อนหน้า
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;
    // ตรวจสอบว่าผู้ใช้มีคะแนนเพียงพอสำหรับการแลกรางวัลหรือไม่
    final canRedeem = user.points >= widget.reward.points;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูปภาพรางวัลขนาดใหญ่พร้อมกรอบ
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        widget.reward.imageUrl,
                        fit: BoxFit.cover,
                        // แสดงไอคอนเมื่อโหลดรูปไม่สำเร็จ
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ชื่อรางวัลพร้อมปุ่มหัวใจ
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.reward.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // ปุ่มหัวใจสำหรับบันทึกรายการโปรด
                            GestureDetector(
                              onTap: _toggleSave,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  widget.reward.isSaved
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: widget.reward.isSaved
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // คะแนนที่ต้องใช้ (จัดรูปแบบด้วยจุลภาค)
                        Text(
                          '${widget.reward.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Points',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // หัวข้อรายละเอียด
                        const Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 1),
                        // รายละเอียดรางวัล
                        Text(
                          widget.reward.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.5, // ระยะห่างบรรทัดสำหรับอ่านง่าย
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ปุ่มแลกรางวัลที่ด้านล่างคงที่
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // เปิด/ปิดปุ่มตามคะแนนที่มี
                onPressed: canRedeem ? _redeemReward : null,
                style: ElevatedButton.styleFrom(
                  // เปลี่ยนสีปุ่มตามสถานะ
                  backgroundColor:
                      canRedeem ? Colors.grey[800] : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Redeem',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
