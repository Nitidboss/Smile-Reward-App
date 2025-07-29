import 'package:flutter/material.dart';
import '../models/reward.dart';

class RewardGrid extends StatelessWidget {
  final List<Reward> rewards; // รายการรางวัลที่จะแสดง
  final Function(Reward) onToggleSave; // Callback เมื่อกดปุ่มหัวใจ
  final Function(Reward) onNavigateToDetail; // Callback เมื่อคลิกดูรายละเอียด

  const RewardGrid({
    super.key,
    required this.rewards,
    required this.onToggleSave,
    required this.onNavigateToDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        // กำหนดการจัดวางแบบกริด
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 คอลัมน์
          childAspectRatio: 0.75,
          crossAxisSpacing: 16, // ระยะห่างระหว่างคอลัมน์
          mainAxisSpacing: 16, // ระยะห่างระหว่างแถว
        ),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          return GestureDetector(
            // คลิกการ์ดเพื่อดูรายละเอียด
            onTap: () => onNavigateToDetail(reward),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                // ใช้ Stack เพื่อวางปุ่มหัวใจทับบนรูป
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // พื้นที่แสดงรูปภาพรางวัล
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            child: Image.network(
                              reward.imageUrl,
                              fit: BoxFit.cover,
                              // แสดงไอคอนเมื่อโหลดรูปไม่สำเร็จ
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // พื้นที่แสดงข้อมูลรางวัล
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ชื่อรางวัล
                              Text(
                                reward.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // ตัดข้อความที่ยาวเกินไป
                              ),
                              const SizedBox(height: 4),
                              // คะแนนที่ต้องใช้ (จัดรูปแบบด้วยจุลภาค)
                              Text(
                                '${reward.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Points',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ปุ่มหัวใจในมุมขวาบน
                  Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () => onToggleSave(reward), // สลับสถานะรายการโปรด
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
                          // แสดงหัวใจเต็มหรือหัวใจกลวงตามสถานะ
                          reward.isSaved
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: reward.isSaved ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
