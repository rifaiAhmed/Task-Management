import 'dart:convert';
import 'package:course_task_app/common/urls.dart';
import 'package:course_task_app/data/models/task.dart';
import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TaskSource {
  static const _baseURL = '${URLs.host}/tasks';
  static Future<bool> add(String title, String description, String dueDate, int userId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURL),
        body: jsonEncode({
            "userId" : userId,
            "title": title,
            "description": description,
            "status": "Queue",
            "dueDate": dueDate
        }),
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> delete(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseURL/$id'),
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> submit(int id, XFile xFile) async {
    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$_baseURL/$id/submit'),
      )..fields['submitDate'] = DateTime.now().toIso8601String()
      ..files.add(
        await http.MultipartFile.fromPath('attachment', xFile.path, filename: xFile.name)
      );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> reject(String reason, String rejectedDate, int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseURL/$id/reject'),
        body: jsonEncode({
            "reason": reason,
            "rejectedDate": DateTime.now().toIso8601String()
        }),
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> fix(int revision, int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseURL/$id/fix'),
        body: jsonEncode({
            "revision": revision
        }),
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> approve(String approvedDate, int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseURL/$id/reject'),
        body: jsonEncode({
            "approvedDate": DateTime.now().toIso8601String()
        }),
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<Task?> findById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/$id'),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        Map resBody = jsonDecode(response.body);
        return Task.fromJson(Map.from(resBody));
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<List<Task>?> needReview() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/need-review'),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        List resBody = jsonDecode(response.body);
        return resBody.map((e) => Task.fromJson(Map.from(e))).toList();
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<List<Task>?> progressTask(int idUser) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/progress-task/$idUser'),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        List resBody = jsonDecode(response.body);
        return resBody.map((e) => Task.fromJson(Map.from(e))).toList();
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<Map?> statistic(int idUser) async {
    List listStatus = ["Queue", "Review", "Approved", "Rejected"];
    Map stat = {};
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/stat/$idUser'),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        List resBody = jsonDecode(response.body);
        for (var status in listStatus) {
         Map? found =  resBody.where((e) => e['status'] == status).firstOrNull();
         stat[status] = found?['total'] ?? 0;
        }
        return stat;
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<List<Task>?> whereUserAndStatus(int idUser, String status) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/user/$idUser/$status'),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        List resBody = jsonDecode(response.body);
        return resBody.map((e) => Task.fromJson(Map.from(e))).toList();
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }
}