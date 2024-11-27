import 'dart:convert';
import 'package:course_task_app/common/urls.dart';
import 'package:d_method/d_method.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserSource {
  static const _baseURL = '${URLs.host}/users';

  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/login'),
        body: jsonEncode({
	        "email": email,
          "password": password
        }),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        Map resBody = jsonDecode(response.body);
        return User.fromJson(Map.from(resBody));
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<(bool, String)> addEmployee(String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURL),
        body: jsonEncode({
	        "name": name,
          "email": email
        }),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 400) {
        return (false, "Email already exist");
      }
      if (response.statusCode != 200) {
        return (false, "failed add employee");
      }
      return (response.statusCode == 200, "Success add employee");
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return (false, e.toString());
    }
  }

  static Future<bool> delete(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseURL/$userId'),
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<List<User>?> getEmployee() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/employee'),
      );
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        List resBody = jsonDecode(response.body);
        return resBody.map((e) => User.fromJson(Map.from(e))).toList();
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }
}