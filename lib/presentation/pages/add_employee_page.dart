import 'package:course_task_app/common/app_info.dart';
import 'package:course_task_app/data/source/user_source.dart';
import 'package:course_task_app/presentation/widgets/app_button.dart';
import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  @override
  Widget build(BuildContext context) {
    final edtName = TextEditingController();
    final edtEmail = TextEditingController();

    addNewEmployee() {
      UserSource.addEmployee(edtName.text, edtEmail.text).then((value) {
        var (status, message) = value;
        if (status) {
          AppInfo.success(context, message);
        } else {
          AppInfo.failed(context, message);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('New Employee'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DInput(
            controller: edtName,
            title: 'Name',
            hint: 'Type name...',
            fillColor: Colors.white,
            radius: BorderRadius.circular(12),
          ),
          const Gap(16),
          DInput(
            controller: edtEmail,
            title: 'Email',
            hint: 'Type email...',
            fillColor: Colors.white,
            radius: BorderRadius.circular(12),
          ),
          const Gap(16),
          AppButton.primary(
            "Add",
            () => addNewEmployee(),
          )
        ],
      ),
    );
  }
}
