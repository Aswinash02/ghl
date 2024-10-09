import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ghl_sales_crm/app_config.dart';
import 'package:ghl_sales_crm/firebase/firebase_repository.dart';
import 'package:ghl_sales_crm/models/login_response_model.dart';
import 'package:ghl_sales_crm/models/logout_response_model.dart';
import 'package:ghl_sales_crm/models/password_confirm_response.dart';
import 'package:ghl_sales_crm/models/password_forgot_model.dart';
import 'package:ghl_sales_crm/models/resend_code_model.dart';
import 'package:ghl_sales_crm/utils/shared_value.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      String? email, String password, String loginBy) async {
    var deviceToken = await FirebaseRepository().getToken();
    var url = Uri.parse('https://sales.ghlindia.com/api/auth/login');

    var post_body = jsonEncode({
      "email": email,
      "password": password,
      "login_by": loginBy,
      "role": "staff",
      "device_token": deviceToken
    });

    try {
      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'X-Requested-With': 'XMLHttpRequest'
          },
          body: post_body);

      if (response.statusCode == 200) {
        return loginResponseFromJson(response.body);
      } else if (response.statusCode == 401) {
        return loginResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }

  Future<LoginResponse?> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});
    var url = Uri.parse("${AppConfig.BASE_URL}/auth/get-user-by-access-token");
    try {
      http.Response response;
      if (access_token.$ != "") {
        response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${access_token.$}",
          },
          body: post_body,
        );

        if (response.statusCode == 200) {
          return loginResponseFromJson(response.body);
        } else {
          print('Failed to make POST request. Error: ${response.statusCode}');
          throw Exception(
              'Failed to make POST request. Error: ${response.statusCode}');
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }

  Future<LogoutResponse> getLogoutResponse() async {
    var deviceToken = await FirebaseRepository().getToken();
    print("post logout=======>$deviceToken ${access_token.$}");
    var post_body = jsonEncode(
        {"device_token": "$deviceToken"});

    var url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
        },
        body: post_body,
      );
      print("post logout=======>$deviceToken ${access_token.$} ======${post_body}");
      if (response.statusCode == 200) {
        print("response Logout : ${response.body}");
        return logoutResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      String verification_code, String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    var url = Uri.parse("${AppConfig.BASE_URL}/auth/password/confirm_reset");
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body,
      );

      if (response.statusCode == 200) {
        return passwordConfirmResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      String? email_or_code, String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    var url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body,
      );

      if (response.statusCode == 200) {
        return resendCodeResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      String? email_or_phone, String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    var url = Uri.parse("${AppConfig.BASE_URL}/auth/password/forget_request");
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body,
      );

      if (response.statusCode == 200) {
        return passwordForgetResponseFromJson(response.body);
      } else if (response.statusCode == 404) {
        return passwordForgetResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }
}
