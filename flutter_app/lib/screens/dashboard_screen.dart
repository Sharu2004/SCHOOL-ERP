import 'package:flutter/material.dart';
import 'student_list_screen.dart';
import 'attendance_screen.dart';
import 'fee_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _DashTile('Students', Icons.people, Colors.blue, const StudentListScreen()),
      _DashTile('Attendance', Icons.fact_check, Colors.green, const AttendanceScreen()),
      _DashTile('Fees', Icons.payments, Colors.orange, const FeeScreen()),
      _DashTile('Notifications', Icons.notifications, Colors.purple, const NotificationsScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), backgroundColor: const Color(0xFF1565C0)),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: tiles.map((t) => _buildTile(context, t)).toList(),
      ),
    );
  }

  Widget _buildTile(BuildContext context, _DashTile t) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => t.destination)),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(t.icon, size: 40, color: t.color),
            const SizedBox(height: 8),
            Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _DashTile {
  final String title;
  final IconData icon;
  final Color color;
  final Widget destination;
  _DashTile(this.title, this.icon, this.color, this.destination);
}
