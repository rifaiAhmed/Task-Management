import 'package:course_task_app/common/app_color.dart';
import 'package:flutter/material.dart';

class AppInfo {
  static success(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColor.approved,),
    );
  }

  static failed(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColor.rejected,),
    );
  }
}