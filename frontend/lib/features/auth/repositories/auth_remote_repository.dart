import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskapp/core/services/sp_service.dart';
import 'package:taskapp/features/auth/repositories/auth_local_repository.dart';
import 'package:taskapp/models/user_model.dart';
import '../../../core/constants/constants.dart';

class AuthRemoteRepository {
  final spService = SpService();
  final authLocalRepository = AuthLocalRepository();
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (res.statusCode != 201) { 
        throw jsonDecode(res.body)['error'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      } 
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/tokenIsValid'),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (res.statusCode != 200|| jsonDecode(res.body)== false) {
        throw jsonDecode(res.body)['error'];
      }

      final userResponce = await http.get(
        Uri.parse('${Constants.backendUrl}/auth'),
        headers: {"Content  -Type": "application/json", "x-auth-token": token},
      );
      print(userResponce.body);

      if (userResponce.statusCode != 200 )  {
         throw jsonDecode(userResponce.body)['error'];
      }

      return UserModel.fromJson(userResponce.body); 
    } catch (e) {
      final user = await authLocalRepository.getUser();
      return user; 
    }
  }
}
