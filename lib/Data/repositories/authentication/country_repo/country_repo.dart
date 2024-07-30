import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nasooh/Data/models/country_model.dart';
import 'package:nasooh/app/keys.dart';
import '../../../../app/global.dart';
import '../../../../app/utils/my_application.dart';

class CountryRepo {
  Future<CountyModel?> getCountries() async {
    try {
      http.Response response = await http.get(
        Uri.parse('${Keys.baseUrl}/client/coredata/country/list'),
        headers: headers,
      );
      Map<String, dynamic> responseMap = json.decode(response.body);
      if (response.statusCode == 200 && responseMap["status"] == 1) {
        final categoryFields = countyModelFromJson(responseMap);
        return categoryFields;
      } else {
        MyApplication.showToastView(message: responseMap["message"]);
      }
    } on TimeoutException catch (e, st) {
      MyApplication.showToastView(message: e.toString());
      if (kDebugMode) {
        print(e);
        log(st.toString());
      }
    } on SocketException catch (e, st) {
      MyApplication.showToastView(message: e.toString());
      if (kDebugMode) {
        print(e);
        log(st.toString());
      }
    } on Error catch (e, st) {
      if (kDebugMode) {
        print(e);
        MyApplication.showToastView(message: e.toString());
        log(st.toString());
      }
    }
    return null;
  }
}
