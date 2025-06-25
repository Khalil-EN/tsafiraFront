import 'dart:convert';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import  'package:http/http.dart' as http;
import 'dart:io';
import '../utils/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "../exceptions/premium_required_exception.dart";
import "../exceptions/session_expired_exception.dart";

class Api {
  static final _storage = FlutterSecureStorage();
  static const baseUrl = 'http://192.168.1.84:8000/api/'; //10.0.0.2
  static helloWorld() async{

    var url = Uri.parse("${baseUrl}hello_world");

    final res = await http.post(url);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      print(data);
      //print('Response data: ${res.body}');
    } else {
      print('Failed to load data');
    }


    }
    static SendData(Map pdata) async{
      var url = Uri.parse("${baseUrl}register");
      final res = await http.post(url,body: pdata);
      if (res.statusCode == 200) {
        print('Response data: ${res.body}');
      } else {
        print('Failed to load data');
      }
    }

    static Authentification(Map pdata) async {
      var url = Uri.parse("${baseUrl}login");
      final res = await http.post(
        url,
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode(pdata),
      );

      //final res = await http.post(url,body: pdata);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        print('Access token: $accessToken');
        print('Refresh token: $refreshToken');

        // Save tokens somewhere (secure storage or memory)
        // For example:
        await saveTokens(accessToken, refreshToken);
        print('Tokens saved securely');


        return true;
      } else {
        return false;
      }

    }
  static Future<Map<String, dynamic>> submitPlanData(Map<String, dynamic> data) async {
    final String? accessToken = await _storage.read(key: 'accessToken');
    final String? refreshToken = await _storage.read(key: 'refreshToken');
    final Uri url = Uri.parse('${baseUrl}suggestedplans3');

    final HttpClient client = HttpClient();

    // Helper: perform the actual request with token
    Future<HttpClientResponse> _sendRequest(String? token) async {
      final HttpClientRequest request = await client.postUrl(url);
      request.headers.set('Content-Type', 'application/json');
      if (token != null) {
        request.headers.set('Authorization', 'Bearer $token');
      }
      request.write(jsonEncode(data));
      return await request.close();
    }

    try {
      HttpClientResponse response = await _sendRequest(accessToken);

      // Handle expired token
      if (response.statusCode == 403 && refreshToken != null) {
        final bool refreshed = await _refreshAccessToken(refreshToken);
        if (refreshed) {
          final String? newAccessToken = await _storage.read(key: 'accessToken');
          response = await _sendRequest(newAccessToken);
        } else {
          throw SessionExpiredException('Session expired. Please log in again.');
        }
      }

      final StringBuffer responseBody = StringBuffer();
      await for (var chunk in response.transform(utf8.decoder)) {
        responseBody.write(chunk);
      }

      final decodedBody = json.decode(responseBody.toString());

      if (response.statusCode == 200) {
        print("Full Response: $decodedBody");
        return decodedBody as Map<String, dynamic>;
      } else if (response.statusCode == 405 && decodedBody['error'] == 'LIMIT_REACHED') {
        throw PremiumRequiredException();
      } else {
        throw Exception('Failed to submit plan data: ${decodedBody['message'] ?? response.reasonPhrase}');
      }
    } finally {
      client.close();
    }
  }



  static Future<List<Map<String, dynamic>>> fetchHotels() async {
    String? token = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');

    Future<http.Response> fetchWithToken(String? token) {
      return http.get(
        Uri.parse('${baseUrl}getHotels2'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
    }

    http.Response response = await fetchWithToken(token);

    if (response.statusCode == 403 && refreshToken != null) {
      // Access token expired, attempt to refresh
      final refreshed = await _refreshAccessToken(refreshToken);
      if (refreshed) {
        token = await _storage.read(key: 'accessToken');
        response = await fetchWithToken(token); // Retry with new access token
      } else {
        throw SessionExpiredException('Session expired. Please log in again.');
      }
    }

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        throw Exception('Expected a list but got: ${decoded.runtimeType}');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRestaurants() async {
    String? token = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');

    Future<http.Response> fetchWithToken(String? token) {
      return http.get(
        Uri.parse('${baseUrl}getRestaurants2'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
    }

    http.Response response = await fetchWithToken(token);

    if (response.statusCode == 403 && refreshToken != null) {
      // Access token expired, attempt to refresh
      final refreshed = await _refreshAccessToken(refreshToken);
      if (refreshed) {
        token = await _storage.read(key: 'accessToken');
        response = await fetchWithToken(token); // Retry with new access token
      } else {
        throw SessionExpiredException('Session expired. Please log in again.');
      }
    }

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchActivities() async {
    String? token = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');

    Future<http.Response> fetchWithToken(String? token) {
      return http.get(
        Uri.parse('${baseUrl}getActivities2'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
    }

    http.Response response = await fetchWithToken(token);

    if (response.statusCode == 403 && refreshToken != null) {
      // Access token expired, attempt to refresh
      final refreshed = await _refreshAccessToken(refreshToken);
      print(refreshed);
      if (refreshed) {
        token = await _storage.read(key: 'accessToken');
        response = await fetchWithToken(token); // Retry with new access token
      } else {
        throw SessionExpiredException('Session expired. Please log in again.');
      }
    }

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<List<Map<String, dynamic>>> searchHotels(Map pdata) async{
    String? token = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');

    final payload = {
      "checkInDate": (pdata["checkInDate"] as DateTime?)?.toIso8601String(),
      "checkOutDate": (pdata["checkOutDate"] as DateTime?)?.toIso8601String(),
      "minPrice": pdata["minPrice"],
      "maxPrice": pdata["maxPrice"],
      "location": pdata["location"],
    };


    Future<http.Response> fetchWithToken(String? token) {
      return http.post(
        Uri.parse("${baseUrl}search/hotels"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );
    }

    http.Response response = await fetchWithToken(token);

    if (response.statusCode == 403 && refreshToken != null) {
      // Access token expired, attempt to refresh
      final refreshed = await _refreshAccessToken(refreshToken);
      if (refreshed) {
        token = await _storage.read(key: 'accessToken');
        response = await fetchWithToken(token); // Retry with new access token
      } else {
        throw SessionExpiredException('Session expired. Please log in again.');
      }
    }

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> searchRestaurants(Map pdata) async{
    String? token = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');

    final payload = {
      "date": (pdata["date"] as DateTime?)?.toIso8601String(),
      "time": (pdata["time"] as TimeOfDay?) != null
          ? "${pdata["time"].hour.toString().padLeft(2, '0')}:${pdata["time"].minute.toString().padLeft(2, '0')}"
          : null,
      "minPrice": pdata["minPrice"],
      "maxPrice": pdata["maxPrice"],
      "location": pdata["location"],
      "nbrGuests": pdata["nbrGuests"],
      "dietaryOptions": pdata["dietaryOptions"],
      "specialFeatures": pdata["specialFeatures"],
      "cuisines": pdata["cuisines"],
    };


    Future<http.Response> fetchWithToken(String? token) {
      return http.post(
        Uri.parse("${baseUrl}search/restaurants"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );
    }

    http.Response response = await fetchWithToken(token);

    if (response.statusCode == 403 && refreshToken != null) {
      // Access token expired, attempt to refresh
      final refreshed = await _refreshAccessToken(refreshToken);
      if (refreshed) {
        token = await _storage.read(key: 'accessToken');
        response = await fetchWithToken(token); // Retry with new access token
      } else {
        throw SessionExpiredException('Session expired. Please log in again.');
      }
    }

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> searchActivities(Map pdata) async{
    String? token = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');

    final payload = {
      "date": (pdata["date"] as DateTime?)?.toIso8601String(),
      "time": (pdata["time"] as TimeOfDay?) != null
          ? "${pdata["time"].hour.toString().padLeft(2, '0')}:${pdata["time"].minute.toString().padLeft(2, '0')}"
          : null,
      "freeOnly": pdata["freeOnly"],
      "location": pdata["location"],
      "participants": pdata["participants"],
      "ageGroups": pdata["ageGroups"],
      "specialRequirements": pdata["specialRequirements"],
      "activityTypes": pdata["activityTypes"],
    };


    Future<http.Response> fetchWithToken(String? token) {
      return http.post(
        Uri.parse("${baseUrl}search/activities"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );
    }

    http.Response response = await fetchWithToken(token);

    if (response.statusCode == 403 && refreshToken != null) {
      // Access token expired, attempt to refresh
      final refreshed = await _refreshAccessToken(refreshToken);
      if (refreshed) {
        token = await _storage.read(key: 'accessToken');
        response = await fetchWithToken(token); // Retry with new access token
      } else {
        throw SessionExpiredException('Session expired. Please log in again.');
      }
    }

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<bool> _refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('${baseUrl}refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'accessToken', value: data['accessToken']);
      return true;
    }

    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    return false;
  }

  static Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refreshToken');

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}logout'),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({ 'refreshToken': refreshToken }),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        await _storage.delete(key: 'accessToken');
        await _storage.delete(key: 'refreshToken');
      } else {
        throw Exception('Logout failed');
      }
    } catch (e) {
      print("Logout error: $e");
      rethrow;
    }
  }



}