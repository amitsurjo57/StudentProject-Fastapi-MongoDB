import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student_project_flutter_fastapi_mongodb/models/student_model.dart';
import 'package:student_project_flutter_fastapi_mongodb/services/app_service.dart';

class UpdateStudentScreen extends StatefulWidget {
  final StudentModel studentModel;

  const UpdateStudentScreen({super.key, required this.studentModel});

  @override
  State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final _cursorColor = Colors.lightGreen;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _didAnythingChange = false;

  bool _inProgress = false;

  final TextStyle _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.lightGreen,
  );

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.studentModel.name;
    _deptController.text = widget.studentModel.department;
    _rollController.text = widget.studentModel.roll.toString();
    _sectionController.text = widget.studentModel.section;
    _phoneController.text = widget.studentModel.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deptController.dispose();
    _rollController.dispose();
    _sectionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        Navigator.pop(context, _didAnythingChange);
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Update Student")),
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
                    decoration: InputDecoration(
                      labelText: "Enter Student Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _deptController,
                    readOnly: true,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      label: Icon(Icons.lock, color: Colors.grey),
                      fillColor: Colors.grey.shade200,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: _cursorColor,
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
                      child: CircularProgressIndicator(
                        color: Colors.lightGreen,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_globalKey.currentState!.validate()) return;

                        try {
                          _inProgress = true;
                          setState(() {});

                          _didAnythingChange = true;

                          Uri uri = Uri.parse(
                            AppService.updateStudent(
                              name: widget.studentModel.name,
                              department: widget.studentModel.department,
                              roll: widget.studentModel.roll,
                            ),
                          );

                          final updatedStudent = {
                            "name": _nameController.text,
                            "department": _deptController.text,
                            "roll": int.parse(_rollController.text),
                            "section": _sectionController.text,
                            "phone": _phoneController.text,
                          };

                          Response response = await patch(
                            uri,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode(updatedStudent),
                          );

                          if (response.statusCode == 200) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Updated Successfully")),
                              );
                            }
                          } else {
                            _didAnythingChange = false;
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Updated Failed")),
                              );
                            }
                          }

                          _inProgress = false;
                          setState(() {});
                        } catch (_) {
                          _didAnythingChange = false;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Something went wrong")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(fixedSize: Size(180, 48)),
                      child: Text('Update Student'),
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
