class TimetableEntry {
  final String subject;
  final int start;
  final int end;

  TimetableEntry({required this.subject, required this.start, required this.end});

  Map<String, dynamic> toMap() => {'subject': subject, 'start': start, 'end': end};

  static TimetableEntry fromMap(Map m) => TimetableEntry(
        subject: m['subject'] as String,
        start: (m['start'] as num).toInt(),
        end: (m['end'] as num).toInt(),
      );
}

class TimetableDay {
  final String day;
  final List<TimetableEntry> sessions;
  TimetableDay({required this.day, required this.sessions});

  Map<String, dynamic> toMap() => {
        'day': day,
        'sessions': sessions.map((s) => s.toMap()).toList(),
      };

  static TimetableDay fromMap(Map m) => TimetableDay(
        day: m['day'] as String,
        sessions: (m['sessions'] as List).map((e) => TimetableEntry.fromMap(e as Map)).toList(),
      );
}
