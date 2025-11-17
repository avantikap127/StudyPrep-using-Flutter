class StudySubject {
  String name;
  StudySubject({required this.name});

  Map<String, dynamic> toMap() => {'name': name};

  static StudySubject fromMap(Map m) => StudySubject(name: m['name'] as String);
}
