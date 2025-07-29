import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../widgets/reward_grid.dart';

/// หน้ารายการโปรดที่แสดงเฉพาะรางวัลที่ผู้ใช้บันทึกไว้
/// ใช้ component RewardGrid เดียวกับหน้าหลักเพื่อความสอดคล้อง
class WishlistPage extends StatefulWidget {
  final List<Reward> rewards; // รายการรางวัลทั้งหมดจาก parent
  final Function(Reward) onToggleSave; // Callback สำหรับจัดการรายการโปรด
  final Function(Reward) onNavigateToDetail; // Callback สำหรับไปหน้ารายละเอียด

  const WishlistPage({
    super.key,
    required this.rewards,
    required this.onToggleSave,
    required this.onNavigateToDetail,
  });

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    // กรองเฉพาะรางวัลที่ถูกบันทึกเป็นรายการโปรด
    final savedRewards =
        widget.rewards.where((reward) => reward.isSaved).toList();

    // แสดงสถานะว่างเมื่อไม่มีรายการโปรด
    if (savedRewards.isEmpty) {
      return const Column(
        children: [
          // หัวข้อหน้า Wishlist
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Wishlist',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // ข้อความและไอคอนสถานะว่าง
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ยังไม่มีรายการโปรด',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'กดปุ่มหัวใจที่รางวัลเพื่อเพิ่มลงรายการโปรด',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // แสดงรายการโปรดที่มีข้อมูล
    return Column(
      children: [
        // หัวข้อหน้า Wishlist
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Wishlist',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // กริดแสดงรางวัลที่บันทึกไว้
        Expanded(
          child: RewardGrid(
            rewards: savedRewards, // แสดงเฉพาะรางวัลที่บันทึกไว้
            onToggleSave: widget.onToggleSave, // ส่งต่อ callback ไป parent
            onNavigateToDetail:
                widget.onNavigateToDetail, // ส่งต่อ callback ไป parent
          ),
        ),
      ],
    );
  }
}
