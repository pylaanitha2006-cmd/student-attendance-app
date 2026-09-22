import 'package:flutter/material.dart';

import '../data/students.dart';
import '../services/whatsapp_service.dart';
import '../widgets/student_tile.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  // Get today's date
  String get todayDate {
    DateTime now = DateTime.now();

    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();

    return '$day-$month-$year';
  }

  // Count absent students
  int get absentCount {
    return students.where((student) => student.isAbsent).length;
  }

  // Count present students
  int get presentCount {
    return students.length - absentCount;
  }

  // Get absent registration numbers
  List<String> get absentRegistrationNumbers {
    return students
        .where((student) => student.isAbsent)
        .map((student) => student.registrationNumber)
        .toList();
  }

  // Select or unselect a student
  void changeAttendance(int index) {
    setState(() {
      students[index].isAbsent =
          !students[index].isAbsent;
    });
  }

  // Share absent students
  Future<void> shareAbsentees() async {

    if (absentRegistrationNumbers.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one absent student.',
          ),
        ),
      );

      return;
    }

    await WhatsAppService.shareAbsentees(
      date: todayDate,
      absentStudents: absentRegistrationNumbers,
    );
  }

  // Clear all selections
  void resetAttendance() {
    setState(() {
      for (var student in students) {
        student.isAbsent = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Student Attendance',
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // Date section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                const Text(
                  'Attendance Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  todayDate,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Attendance summary
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade50,
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

              children: [

                Column(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      students.length.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    const Text(
                      'Present',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      presentCount.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    const Text(
                      'Absent',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      absentCount.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Student list
          Expanded(
            child: ListView.builder(

              itemCount: students.length,

              itemBuilder: (context, index) {

                return StudentTile(
                  student: students[index],

                  onChanged: () {
                    changeAttendance(index);
                  },
                );
              },
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(12),

            child: Row(
              children: [

                // Reset button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: resetAttendance,

                    icon: const Icon(
                      Icons.refresh,
                    ),

                    label: const Text(
                      'Reset',
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Share button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: shareAbsentees,

                    icon: const Icon(
                      Icons.share,
                    ),

                    label: const Text(
                      'Share Absentees',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}