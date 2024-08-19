import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api-pm-mdc3.onrender.com';

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/login/$username/$password'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String address,
    required String phone,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/user/register/$name/$email/$address/$phone/$username/$password'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserMachines(String userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user_machine/$userId'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Failed to fetch user machines: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching user machines: $error');
      return [];
    }
  }

  Future<void> fetchUpdateStatus(String id, String idUserMachine, String place,
      int status, int time) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/control/status/$id/$idUserMachine/$place/$status/$time'),
      );
      if (response.statusCode == 200) {
        print('Update successful');
      } else {
        print('Failed to update: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating: $error');
    }
  }

  Future<void> insertUserMachine(
      String userId, String scanBarcode, String place) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user_machine/$userId/$scanBarcode/$place'),
      );
      if (response.statusCode != 200) {
        print('Failed to insert user machine: ${response.statusCode}');
      }
    } catch (error) {
      print('Error inserting user machine: $error');
    }
  }

  Future<void> updateUserMachine(String id, String idUserMachine, String place,
      String status, String time, String date) async {
    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/control/$id/$idUserMachine/$place/$status/$time/$date'),
      );
      if (response.statusCode != 200) {
        print('Failed to update user machine: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating user machine: $error');
    }
  }

  Future<void> deleteUserMachine(String id, String ids) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/usermachine_control/$ids/$id'),
      );
      if (response.statusCode != 200) {
        print('Failed to delete user machine: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting user machine: $error');
    }
  }

  Future<Map<String, dynamic>> fetchData(String endpoint, String id) async {
    print(endpoint);
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}
