class Student {
  final int id;
  final String admissionNo;
  final String fullName;
  final String className;
  final String? section;
  final String? parentName;
  final String? parentContact;

  Student({
    required this.id,
    required this.admissionNo,
    required this.fullName,
    required this.className,
    this.section,
    this.parentName,
    this.parentContact,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: int.parse(json['id'].toString()),
      admissionNo: json['admission_no'] ?? '',
      fullName: json['full_name'] ?? '',
      className: json['class_name'] ?? '',
      section: json['section'],
      parentName: json['parent_name'],
      parentContact: json['parent_contact'],
    );
  }

  Map<String, dynamic> toJson() => {
        'admission_no': admissionNo,
        'full_name': fullName,
        'class_name': className,
        'section': section,
        'parent_name': parentName,
        'parent_contact': parentContact,
      };
}
