import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Cpi {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final String _url = "https://sagunplyapi.prabidhienterprises.com/api/";
  postData(data, apiUrl) async {
    String? token = await storage.read(key: "token");
    var fullUrl = _url + apiUrl;
    return await http
        .post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });
  }
}
