import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student_project_flutter_fastapi_mongodb/models/student_model.dart';
import 'package:student_project_flutter_fastapi_mongodb/services/app_service.dart';

class StudentSearchScreen extends StatefulWidget {
  const StudentSearchScreen({super.key});

  @override
  State<StudentSearchScreen> createState() => _StudentSearchScreenState();
}

class _StudentSearchScreenState extends State<StudentSearchScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _rollController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  StudentModel? studentModel;

  final TextStyle _secondScreenTextStyle = TextStyle(fontSize: 20);

  bool _inProgress = false;

  String _myValue = "CSE";

  @override
  void dispose() {
    _pageController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Student'),
        // automaticallyImplyLeading: false,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _firstScreen(),
          _secondScreen(student: studentModel),
        ],
      ),
    );
  }

  Widget _firstScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
      child: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            children: [
              DropdownButtonFormField(
                initialValue: _myValue,
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(labelText: "Enter Department"),
                items: [
                  DropdownMenuItem(value: "CSE", child: Text("CSE")),
                  DropdownMenuItem(value: "EEE", child: Text("EEE")),
                  DropdownMenuItem(value: "IPE", child: Text("IPE")),
                  DropdownMenuItem(value: "FDAE", child: Text("FDAE")),
                  DropdownMenuItem(value: "TE", child: Text("TE")),
                ],
                onChanged: (value) {
                  _myValue = value!;
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field can't be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rollController,
                cursorColor: Colors.lightGreen,
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter Roll"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field can't be empty";
                  }
                  return null;
                },
              ),
              Visibility(
                visible: !_inProgress,
                replacement: Center(
                  child: CircularProgressIndicator(color: Colors.lightGreen),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_globalKey.currentState!.validate()) return;

                    try {
                      _inProgress = true;
                      setState(() {});

                      Uri uri = Uri.parse(
                        AppService.searchStudent(
                          department: _myValue.toUpperCase(),
                          roll: int.parse(_rollController.text),
                        ),
                      );

                      Response response = await get(uri);

                      final decodedResponse = jsonDecode(response.body);

                      studentModel = StudentModel(
                        name: decodedResponse['name'],
                        department: decodedResponse['department'],
                        roll: decodedResponse['roll'],
                        section: decodedResponse['section'],
                        phone: decodedResponse['phone'],
                      );

                      if (response.statusCode == 200) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Student found")),
                          );
                        }
                      }

                      _inProgress = false;
                      setState(() {});

                      await _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    } catch (_) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Student not found")),
                        );
                      }
                      _inProgress = false;
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(180, 48)),
                  child: Text("Search Student"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secondScreen({StudentModel? student}) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        await _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text("Name: ${student?.name ?? ""}", style: _secondScreenTextStyle),
            Text(
              "Department: ${student?.department ?? ""}",
              style: _secondScreenTextStyle,
            ),
            Text("Roll: ${student?.roll ?? ""}", style: _secondScreenTextStyle),
            Text(
              "Section: ${student?.section ?? ""}",
              style: _secondScreenTextStyle,
            ),
            Text(
              "Phone: ${student?.phone ?? ""}",
              style: _secondScreenTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
