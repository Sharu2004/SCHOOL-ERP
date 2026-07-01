class AttendanceRecord {
  final int studentId;
  final String date;
  final String status; // present, absent, late

  AttendanceRecord({required this.studentId, required this.date, required this.status});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      studentId: int.parse(json['student_id'].toString()),
      date: json['attendance_date'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'attendance_date': date,
        'status': status,
      };
}
