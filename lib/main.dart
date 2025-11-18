import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:student_project_flutter_fastapi_mongodb/themes/app_themes.dart';
import 'package:student_project_flutter_fastapi_mongodb/ui/screens/student_list_screen.dart';

void main() {
  runApp(const StudentProjectFlutterFastapiMongodb());
}

final Logger logger = Logger();

class StudentProjectFlutterFastapiMongodb extends StatelessWidget {
  const StudentProjectFlutterFastapiMongodb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      home: StudentListScreen(),
    );
  }
}
