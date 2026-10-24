// lib/models/course.dart

class Course {
  final String code;
  final String title;
  final int credits;
  final String status;
  final String instructor; 
  final bool done;         

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    required this.instructor,
    required this.done,
  });
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String? ?? 'Active',
      instructor: json['instructor'] as String? ?? '-', 
      done: json['done'] as bool? ?? false,             
    );
  }
}