import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../services/auth_service.dart';
import '../services/reward_service.dart';
import '../widgets/reward_grid.dart';
import 'login_page.dart';
import 'reward_detail_page.dart';
import 'wishlist_page.dart';

/// หน้าหลักของแอพที่แสดงหลังจากล็อกอินสำเร็จ
/// ประกอบด้วยการแสดงข้อมูลผู้ใช้ รายการรางวัล และการนำทางระหว่างแท็บ
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Reward> rewards = []; // รายการรางวัลทั้งหมดในระบบ
  int _selectedIndex = 0; // แท็บที่เลือกปัจจุบัน (0=Home, 1=Wishlist)

  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลรางวัลเมื่อ widget ถูกสร้างขึ้น
    rewards = RewardService.getAllRewards();
  }

  /// จัดการการเปลี่ยนแท็บใน Bottom Navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// ล็อกเอาต์ผู้ใช้และกลับไปหน้าล็อกอิน
  void _signOut() {
    AuthService.logout(); // ลบข้อมูลผู้ใช้
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  /// สลับสถานะการบันทึกรายการโปรดของรางวัล
  void _toggleSave(Reward reward) {
    setState(() {
      reward.isSaved = !reward.isSaved; // สลับสถานะ true <-> false
    });
  }

  /// นำทางไปหน้ารายละเอียดรางวัล
  /// รีเฟรช UI เมื่อกลับมา (เผื่อคะแนนเปลี่ยนแปลง)
  void _navigateToDetail(Reward reward) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => RewardDetailPage(reward: reward),
      ),
    )
        .then((_) {
      setState(() {}); // รีเฟรชหน้าเมื่อกลับมาจากหน้ารายละเอียด
    });
  }

  /// สร้าง widget สำหรับแสดงรายการรางวัลในหน้าหลัก
  Widget _buildHomeView() {
    return RewardGrid(
      rewards: rewards,
      onToggleSave: _toggleSave,
      onNavigateToDetail: _navigateToDetail,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!; // ดึงข้อมูลผู้ใช้ปัจจุบัน

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // ซ่อนปุ่มกลับ
        // แสดง title เฉพาะในแท็บ Home (index 0)
        title: _selectedIndex == 0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // แสดงชื่อผู้ใช้
                          Text(
                            'คุณ ${user.fullName}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // แสดงคะแนนปัจจุบัน (จัดรูปแบบด้วยจุลภาค)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${user.points.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                ' points',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ปุ่มล็อกเอาต์
                    ElevatedButton(
                      onPressed: _signOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 47, 48, 47),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null, // ไม่แสดง title ในแท็บอื่น ๆ
        centerTitle: false,
      ),
      // ใช้ IndexedStack เพื่อรักษาสถานะของแต่ละแท็บ
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeView(), // แท็บ Home
          WishlistPage(
            // แท็บ Wishlist
            rewards: rewards,
            onToggleSave: _toggleSave,
            onNavigateToDetail: _navigateToDetail,
          ),
        ],
      ),
      // แถบนำทางด้านล่าง
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
        ],
        currentIndex: _selectedIndex, // แท็บที่เลือกปัจจุบัน
        selectedItemColor: Colors.black, // สีของแท็บที่เลือก
        onTap: _onItemTapped, // จัดการการแตะแท็บ
      ),
    );
  }
}
