// Update this to your deployed backend URL or local IP (e.g. http://10.0.2.2/backend_php for Android emulator)
class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2/backend_php';

  static const String login = '$baseUrl/auth.php?action=login';
  static const String register = '$baseUrl/auth.php?action=register';
  static const String students = '$baseUrl/students.php';
  static const String attendance = '$baseUrl/attendance.php';
  static const String fees = '$baseUrl/fees.php';
  static const String notifications = '$baseUrl/notifications.php';
}

class AppColors {
  static const primary = 0xFF1565C0;
  static const accent = 0xFF00ACC1;
}
