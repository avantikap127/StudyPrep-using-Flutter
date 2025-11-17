class TimeSlot {
  final String label; // e.g., "Morning"
  final int start; // hour in 24h (e.g., 7)
  final int end;   // hour in 24h (e.g., 9)

  TimeSlot({required this.label, required this.start, required this.end});

  Map<String, dynamic> toMap() => {
        'label': label,
        'start': start,
        'end': end,
      };

  static TimeSlot fromMap(Map m) => TimeSlot(
        label: m['label'] as String,
        start: (m['start'] as num).toInt(),
        end: (m['end'] as num).toInt(),
      );

  String display() => '$label: ${start.toString().padLeft(2,'0')}–${end.toString().padLeft(2,'0')}';
}
