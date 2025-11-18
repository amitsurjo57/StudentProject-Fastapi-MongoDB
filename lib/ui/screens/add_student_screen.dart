import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student_project_flutter_fastapi_mongodb/services/app_service.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _cursorColor = Colors.lightGreen;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _inProgress = false;
  bool _didChange = false;

  String _myValue = "CSE";

  final TextStyle _textStyle = TextStyle(
    color: Colors.lightGreen,
    fontWeight: FontWeight.w500,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _sectionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Navigator.pop(context, _didChange);
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Add Student")),
        body: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                spacing: 12,
                children: [
                  SizedBox(height: 28),
                  TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: _textStyle,
                    cursorColor: _cursorColor,
                    decoration: InputDecoration(labelText: "Enter Student Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    initialValue: _myValue,
                    style: _textStyle.copyWith(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: _textStyle,
                    cursorColor: _cursorColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Enter Roll"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sectionController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: _textStyle,
                    cursorColor: _cursorColor,
                    decoration: InputDecoration(labelText: "Enter Section"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: _textStyle,
                    cursorColor: _cursorColor,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: "Enter Phone"),
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
                          _didChange = true;
                          _inProgress = true;
                          setState(() {});

                          final newStudent = {
                            'name': _nameController.text,
                            'department': _myValue,
                            'roll': int.parse(_rollController.text),
                            'section': _sectionController.text.toUpperCase(),
                            'phone': _phoneController.text.toString(),
                          };

                          Uri uri = Uri.parse(
                            AppService.createStudent(department: _myValue),
                          );
                          Response response = await post(
                            uri,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode(newStudent),
                          );

                          if (response.statusCode == 200) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("New Student Added Successfully"),
                                ),
                              );
                            }
                          } else {
                            _didChange = false;
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("New Student Couldn't Added"),
                                ),
                              );
                            }
                          }

                          _inProgress = false;
                          setState(() {});
                        } catch (_) {
                          _didChange = false;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Something went wrong")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(fixedSize: Size(150, 48)),
                      child: Text('Add Student'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
