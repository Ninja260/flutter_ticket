import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket/exception/api_call_exception.dart';
import 'package:ticket/model/response.dart';
import 'package:ticket/utils/logger.dart';

class HttpUtil {
  static const String baseUrl = 'http://10.0.0.41:3000/api';

  static SharedPreferences? pref;

  static Future<Response> get(String endpoint,
      [Map<String, dynamic>? queryParameters]) async {
    var uri = _getUri(baseUrl, endpoint, queryParameters);
    final response = await http.get(
      uri,
      headers: await _getHearder(),
    );
    var res = _handleResponse(response);
    _checkResponse(uri.toString(), 'POST', res);

    return res;
  }

  static Future<Response> post(String endpoint, dynamic body) async {
    var uri = _getUri(baseUrl, endpoint);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: await _getHearder(),
    );
    var res = _handleResponse(response);
    _checkResponse(uri.toString(), 'POST', res);

    return res;
  }

  static Future<Response> put(String endpoint, dynamic body) async {
    var uri = _getUri(baseUrl, endpoint);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: await _getHearder(),
    );

    var res = _handleResponse(response);
    _checkResponse(uri.toString(), 'PUT', res);

    return res;
  }

  static Future<Response> delete(String endpoint) async {
    var uri = _getUri(baseUrl, endpoint);
    final response = await http.delete(
      uri,
      headers: await _getHearder(),
    );

    var res = _handleResponse(response);
    _checkResponse(uri.toString(), 'DELETE', res);

    return res;
  }

  static Response _handleResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final dynamic responseBody = jsonDecode(response.body);

    return Response(
      status: statusCode,
      body: responseBody,
    );
  }

  static Future<Map<String, String>> _getHearder() async {
    var headers = {'Content-Type': 'application/json'};
    pref = pref ?? await SharedPreferences.getInstance();

    String? token = pref!.getString("token");

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Uri _getUri(String baseUrl,
      [String path = '', Map<String, dynamic>? queryParameters]) {
    // parse query parameter
    String queryParam = '';
    if (queryParameters != null) {
      for (var key in queryParameters.keys) {
        if (queryParam.isNotEmpty) queryParam += '&';
        queryParam += '$key=${Uri.encodeComponent(queryParameters[key])}';
      }
    }
    if (queryParam.isNotEmpty) queryParam = '?$queryParam';
    return Uri.parse('$baseUrl$path$queryParam');
  }

  static void _checkResponse(String url, String method, Response response) {
    int status = response.status;
    dynamic body = response.body;

    switch (status) {
      case 400:
        throw ApiCallException(
          httpStatus: 400,
          title: "Input",
          message: 'Please carefully fill up inputs',
        );
      case 403:
        throw ApiCallException(
          httpStatus: 403,
          title: "Unauthorized",
          message: body['errors']['message'],
        );
      case 401:
        throw ApiCallException(
          httpStatus: 401,
          title: "Session",
          message: "Invalid Session!",
        );
      case 422:
        throw ApiCallException(
          httpStatus: 422,
          title: "Error",
          message: body['errors']['message'],
        );
      case 500:
        throw ApiCallException(
          httpStatus: 500,
          title: "Server",
          message: "Internal Server Error!",
        );
    }

    if (status < 200 && status >= 300) {
      var obj = {
        body: body,
        url: url,
        method: method,
      };
      logger.e('Unknown Error: $status', obj);
      throw ApiCallException(
        httpStatus: status,
        title: "Unknow Error",
        message: "Opps! Something went wrong!",
      );
    }
  }
}
