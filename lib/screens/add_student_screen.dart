import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../providers/class_provider.dart';

class AddStudentScreen extends StatefulWidget {
  final String? classId;

  const AddStudentScreen({
    super.key,
    this.classId,
  });

  @override
  State<AddStudentScreen> createState() =>
      _AddStudentScreenState();
}

class _AddStudentScreenState
    extends State<AddStudentScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final student = Student(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      name: nameController.text.trim(),
      completedLessons: 0,
      xp: 0,
      progress: 0,
    );

    await context.read<ClassProvider>().addStudent(
          student,
          classId: widget.classId,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "🎉 Barataan milkaa'inaan dabalame.",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Barataa Haaraa Dabali 👧",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              const CircleAvatar(
                radius: 45,
                child: Icon(
                  Icons.person_add,
                  size: 45,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: nameController,

                decoration: const InputDecoration(
                  labelText: "Maqaa Barataa",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Maqaa galchi";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(

                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),

                  label: Text(
                    _saving
                        ? "Olkaa'aa jira..."
                        : "Olkaa'i",
                  ),

                  onPressed:
                      _saving ? null : _saveStudent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}