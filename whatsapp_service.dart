import 'package:share_plus/share_plus.dart';

class WhatsAppService {
  static Future<void> shareAbsentees({
    required String date,
    required List<String> absentStudents,
  }) async {
    if (absentStudents.isEmpty) {
      return;
    }

    String message = 'Absent Students\n';
    message += 'Date: $date\n\n';

    for (int i = 0; i < absentStudents.length; i++) {
      message += '${i + 1}. ${absentStudents[i]}\n';
    }

    message += '\nTotal Absentees: ${absentStudents.length}';

    await SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: 'Absent Students - $date',
      ),
    );
  }
}