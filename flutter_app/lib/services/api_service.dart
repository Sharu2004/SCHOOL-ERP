import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/student.dart';
import '../models/fee.dart';

class ApiService {
  // ---- Auth ----
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(res.body);
  }

  // ---- Students ----
  static Future<List<Student>> getStudents({String? className}) async {
    final uri = className != null
        ? Uri.parse('${ApiConstants.students}?class=$className')
        : Uri.parse(ApiConstants.students);
    final res = await http.get(uri);
    final List data = jsonDecode(res.body);
    return data.map((e) => Student.fromJson(e)).toList();
  }

  static Future<bool> addStudent(Student student) async {
    final res = await http.post(
      Uri.parse(ApiConstants.students),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson()),
    );
    return res.statusCode == 200;
  }

  // ---- Attendance ----
  static Future<bool> markAttendance(int studentId, String date, String status) async {
    final res = await http.post(
      Uri.parse(ApiConstants.attendance),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'student_id': studentId, 'attendance_date': date, 'status': status}),
    );
    return res.statusCode == 200;
  }

  // ---- Fees ----
  static Future<List<Fee>> getFees(int studentId) async {
    final res = await http.get(Uri.parse('${ApiConstants.fees}?student_id=$studentId'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Fee.fromJson(e)).toList();
  }

  static Future<bool> payFee(int feeId, double amount) async {
    final res = await http.post(
      Uri.parse(ApiConstants.fees),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fee_id': feeId, 'amount_paid': amount}),
    );
    return res.statusCode == 200;
  }

  // ---- Notifications ----
  static Future<List<dynamic>> getNotifications() async {
    final res = await http.get(Uri.parse(ApiConstants.notifications));
    return jsonDecode(res.body);
  }
}
