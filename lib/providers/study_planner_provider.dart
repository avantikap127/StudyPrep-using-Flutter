import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/study_subject.dart';
import '../models/time_slot.dart';
import '../models/timetable_day.dart';

class StudyPlannerProvider with ChangeNotifier {
  static const _subjectsBox = 'planner_subjects';
  static const _timesBox = 'planner_timeslots';
  static const _tableBox = 'planner_timetable';

  late Box subjectsBox;
  late Box timesBox;
  late Box tableBox;

  List<StudySubject> subjects = [];
  List<TimeSlot> timeslots = [];
  List<TimetableDay> timetable = [];

  Future<void> init() async {
    subjectsBox = await Hive.openBox(_subjectsBox);
    timesBox = await Hive.openBox(_timesBox);
    tableBox = await Hive.openBox(_tableBox);

    _loadFromBoxes();
  }

  void _loadFromBoxes() {
    subjects = subjectsBox.values.map((e) => StudySubject.fromMap(Map<String, dynamic>.from(e))).toList();
    timeslots = timesBox.values.map((e) => TimeSlot.fromMap(Map<String, dynamic>.from(e))).toList();
    timetable = tableBox.values.map((e) => TimetableDay.fromMap(Map<String, dynamic>.from(e))).toList();
    notifyListeners();
  }

  // Subjects
  Future addSubject(StudySubject s) async {
    await subjectsBox.add(s.toMap());
    _loadFromBoxes();
  }

  Future removeSubjectAt(int idx) async {
    await subjectsBox.deleteAt(idx);
    _loadFromBoxes();
  }

  // Time slots
  Future addTimeSlot(TimeSlot t) async {
    await timesBox.add(t.toMap());
    _loadFromBoxes();
  }

  Future removeTimeSlotAt(int idx) async {
    await timesBox.deleteAt(idx);
    _loadFromBoxes();
  }

  // Timetable generation & storage
  Future generateAndSaveTimetable() async {
    final gen = _generateTimetable(subjects, timeslots);
    await tableBox.clear();
    for (var d in gen) {
      await tableBox.add(d.toMap());
    }
    _loadFromBoxes();
  }

  // returns generated in memory (no save)
  List<TimetableDay> generateTimetable() => _generateTimetable(subjects, timeslots);

  List<TimetableDay> _generateTimetable(List<StudySubject> subjects, List<TimeSlot> slots) {
    final week = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    final List<TimetableDay> out = [];

    if (subjects.isEmpty || slots.isEmpty) return week.map((d) => TimetableDay(day: d, sessions: [])).toList();

    for (int i = 0; i < week.length; i++) {
      final day = week[i];
      final List<TimetableEntry> sessions = [];
      for (int j = 0; j < slots.length; j++) {
        final sIdx = (i + j) % subjects.length;
        final subjectName = subjects[sIdx].name;
        sessions.add(TimetableEntry(subject: subjectName, start: slots[j].start, end: slots[j].end));
      }
      out.add(TimetableDay(day: day, sessions: sessions));
    }
    return out;
  }
}
