import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/study_planner_provider.dart';
import '../../models/time_slot.dart';

class AddTimeSlotsScreen extends StatefulWidget {
  const AddTimeSlotsScreen({super.key});
  @override
  State<AddTimeSlotsScreen> createState() => _AddTimeSlotsScreenState();
}

class _AddTimeSlotsScreenState extends State<AddTimeSlotsScreen> {
  final labelCtrl = TextEditingController();
  int start = 7;
  int end = 8;

  Widget hourDropdown(int value, void Function(int?) onChanged) {
    final hours = List.generate(24, (i) => i);
    return DropdownButton<int>(
      value: value,
      onChanged: onChanged,
      items: hours.map((h) => DropdownMenuItem(value: h, child: Text(h.toString()))).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyPlannerProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Time Slots')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Row(children: [
            Expanded(child: TextField(controller: labelCtrl, decoration: const InputDecoration(labelText: 'Label (e.g., Morning)'))),
            const SizedBox(width: 8),
            hourDropdown(start, (v) => setState(() => start = v ?? start)),
            const SizedBox(width: 8),
            Text('-', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            hourDropdown(end, (v) => setState(() => end = v ?? end)),
            const SizedBox(width: 8),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final label = labelCtrl.text.trim();
                if (label.isEmpty || start >= end) return;
                provider.addTimeSlot(TimeSlot(label: label, start: start, end: end));
                labelCtrl.clear();
                setState(() { start = 7; end = 8; });
              },
            ),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: provider.timeslots.length,
              itemBuilder: (_, i) {
                final t = provider.timeslots[i];
                return ListTile(
                  title: Text(t.display()),
                  trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => provider.removeTimeSlotAt(i)),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
