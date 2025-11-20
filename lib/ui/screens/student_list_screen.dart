import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student_project_flutter_fastapi_mongodb/models/student_model.dart';
import 'package:student_project_flutter_fastapi_mongodb/services/app_service.dart';
import 'package:student_project_flutter_fastapi_mongodb/ui/screens/add_student_screen.dart';
import 'package:student_project_flutter_fastapi_mongodb/ui/screens/student_search_screen.dart';
import 'package:student_project_flutter_fastapi_mongodb/ui/screens/update_student_screen.dart';
import 'package:student_project_flutter_fastapi_mongodb/ui/widgets/student_widget.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final List<StudentModel> _listOfStudents = [];

  bool _inProgress = false;

  String dropDownValue = "CSE";

  @override
  void initState() {
    super.initState();
    _getStudentsList();
  }

  Future<void> _getStudentsList() async {
    _listOfStudents.clear();
    _inProgress = true;
    setState(() {});

    Uri uri = Uri.parse(
      AppService.getStudentsByDepartment(department: dropDownValue),
    );

    Response response = await get(uri);

    final decodedResponse = jsonDecode(response.body);

    for (var student in decodedResponse) {
      _listOfStudents.add(
        StudentModel(
          name: student['data']['name'],
          department: student['data']['department'],
          roll: student['data']['roll'],
          section: student['data']['section'],
          phone: student['data']['phone'],
        ),
      );
    }

    _inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectableText('Students List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentSearchScreen()),
              );
            },
            icon: Icon(Icons.search, size: 28),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen.shade100,
        foregroundColor: Colors.green,
        child: Icon(Icons.add, size: 36),
        onPressed: () async {
          bool didChange = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );
          if (didChange) _getStudentsList();
        },
      ),
      body: RefreshIndicator(
        onRefresh: _getStudentsList,
        color: Colors.lightGreen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 16,
            children: [_buildDeptList(), _buildStudentList()],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return Expanded(
      child: Visibility(
        visible: !_inProgress,
        replacement: Center(
          child: CircularProgressIndicator(color: Colors.lightGreen),
        ),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: _listOfStudents.length,
          itemBuilder: (context, index) => StudentWidget(
            studentModel: _listOfStudents[index],
            onUpdate: () async {
              bool didChange = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UpdateStudentScreen(studentModel: _listOfStudents[index]),
                ),
              );

              if (didChange) _getStudentsList();
            },
            onDelete: () async {
              Uri uri = Uri.parse(
                AppService.deleteStudent(
                  name: _listOfStudents[index].name,
                  department: _listOfStudents[index].department,
                  roll: _listOfStudents[index].roll,
                ),
              );

              Response response = await delete(uri);

              if (response.statusCode == 200) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Student of Roll: ${_listOfStudents[index].roll} Deleted Successfully.",
                      ),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Deletion Failed")));
                }
              }

              _getStudentsList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDeptList() {
    return Row(
      mainAxisAlignment: .start,
      spacing: 12,
      children: [
        SelectableText(
          "Select Department:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        DropdownButton(
          value: dropDownValue,
          items: [
            DropdownMenuItem(value: "CSE", child: Text('CSE')),
            DropdownMenuItem(value: "EEE", child: Text('EEE')),
            DropdownMenuItem(value: "IPE", child: Text('IPE')),
            DropdownMenuItem(value: "FDAE", child: Text('FDAE')),
            DropdownMenuItem(value: "TE", child: Text('TE')),
          ],
          onChanged: (value) {
            dropDownValue = value!;
            _getStudentsList();
            setState(() {});
          },
          alignment: Alignment.center,
          underline: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey),
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
