import 'package:flutter/material.dart';
import 'package:student_project_flutter_fastapi_mongodb/models/student_model.dart';

class StudentWidget extends StatelessWidget {
  final void Function() onUpdate;
  final void Function() onDelete;
  final StudentModel studentModel;

  const StudentWidget({
    super.key,
    required this.studentModel,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: double.infinity,
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            SizedBox(
              width: constraints.maxWidth / 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  children: [
                    SelectableText("Name: ${studentModel.name}"),
                    SelectableText("Department: ${studentModel.department}"),
                    SelectableText("Roll: ${studentModel.roll}"),
                    SelectableText("Section: ${studentModel.section}"),
                    SelectableText("Phone: ${studentModel.phone}"),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              children: [
                ElevatedButton.icon(
                  onPressed: onUpdate,
                  label: Text("Update"),
                  icon: Icon(Icons.edit, color: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: onDelete,
                  label: Text("Delete"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
