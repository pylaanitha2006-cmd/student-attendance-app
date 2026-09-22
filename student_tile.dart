import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final VoidCallback onChanged;

  const StudentTile({
    super.key,
    required this.student,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      child: CheckboxListTile(
        value: student.isAbsent,
        onChanged: (value) {
          onChanged();
        },
        title: Text(
          student.registrationNumber,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        secondary: const Icon(
          Icons.person,
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}