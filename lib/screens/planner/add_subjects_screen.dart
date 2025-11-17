import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/study_planner_provider.dart';
import '../../models/study_subject.dart';

class AddSubjectsScreen extends StatefulWidget {
  const AddSubjectsScreen({super.key});
  @override
  State<AddSubjectsScreen> createState() => _AddSubjectsScreenState();
}

class _AddSubjectsScreenState extends State<AddSubjectsScreen> {
  final ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyPlannerProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Row(children: [
            Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Subject name'))),
            const SizedBox(width: 8),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final v = ctrl.text.trim();
                if (v.isEmpty) return;
                provider.addSubject(StudySubject(name: v));
                ctrl.clear();
              },
            )
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: provider.subjects.length,
              itemBuilder: (_, i) {
                final s = provider.subjects[i];
                return ListTile(
                  title: Text(s.name),
                  trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => provider.removeSubjectAt(i)),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
