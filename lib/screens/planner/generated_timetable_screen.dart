import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/study_planner_provider.dart';
import '../../models/timetable_day.dart';

class GeneratedTimetableScreen extends StatelessWidget {
  const GeneratedTimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyPlannerProvider>(context);

    final List<TimetableDay> generated = provider.generateTimetable();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Timetable'),
        actions: [
          TextButton(
            onPressed: () async {
              await provider.generateAndSaveTimetable();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved timetable locally')));
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: generated.length,
        itemBuilder: (_, i) {
          final day = generated[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(day.day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...day.sessions.map((s) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.subject),
                      trailing: Text('${s.start}:00 - ${s.end}:00'),
                    )),
              ]),
            ),
          );
        },
      ),
    );
  }
}
