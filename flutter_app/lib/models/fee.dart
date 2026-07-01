class Fee {
  final int id;
  final int studentId;
  final String term;
  final double amountDue;
  final double amountPaid;
  final String status;

  Fee({
    required this.id,
    required this.studentId,
    required this.term,
    required this.amountDue,
    required this.amountPaid,
    required this.status,
  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      id: int.parse(json['id'].toString()),
      studentId: int.parse(json['student_id'].toString()),
      term: json['term'],
      amountDue: double.parse(json['amount_due'].toString()),
      amountPaid: double.parse(json['amount_paid'].toString()),
      status: json['status'],
    );
  }

  double get balance => amountDue - amountPaid;
}
