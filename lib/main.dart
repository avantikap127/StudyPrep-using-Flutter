import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/flashcard.dart';
import 'providers/flashcard_provider.dart';
import 'providers/study_planner_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FlashcardAdapter());

  // ---------- OPEN ALL HIVE BOXES ----------
  final flashcardBox = await Hive.openBox('flashcards');
  await Hive.openBox('planner_subjects');
  await Hive.openBox('planner_timeslots');
  await Hive.openBox('planner_timetable');

  // ---------- CREATE PROVIDERS ----------
  final flashProvider = FlashcardProvider();
  await flashProvider.load(flashcardBox);

  final plannerProvider = StudyPlannerProvider();
  await plannerProvider.init();

  // ---------- RUN APP ----------
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FlashcardProvider>.value(value: flashProvider),
        ChangeNotifierProvider<StudyPlannerProvider>.value(value: plannerProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Study Assistant",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
