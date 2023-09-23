import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nasooh/Data/models/send_advise_model.dart';
import 'package:nasooh/app/global.dart';
import 'package:nasooh/app/keys.dart';
import '../../../app/utils/myApplication.dart';
import '../../../app/utils/sharedPreferenceClass.dart';
import 'package:http/http.dart' as http;

import '../models/advice_screen_models/show_advice_model.dart';

class SendAdvise {
  Future<ShowAdviceModel?> sendAdvise({
    String? name,
    String? description,
    String? price,
    String? documentsFile,
    int? adviserId,
  }) async {
    try {
      http.Response response = await http
          .post(Uri.parse('${Keys.baseUrl}/client/advice/store'), headers: {
        'Accept': 'application/json',
        'lang': selectedLang,
        "Authorization": "Bearer ${sharedPrefs.getToken()}"
      }, body: {
        'name': name,
        'description': '$description',
        'adviser_id': '$adviserId',
        'price': '$price',
        'documents[][file]':'$documentsFile' ,
        'documents[][type]':'png'
      });
      Map<String, dynamic> responseMap = json.decode(response.body);
      if (response.statusCode == 200 && responseMap["status"] == 1) {
        print(response.body);
        final userdata = showAdviceModelFromJson(responseMap);
        MyApplication.showToastView(message: responseMap["message"]);
        return userdata;
      } else {
        MyApplication.showToastView(
            message: responseMap["message"].values.toString());
      }
    } on TimeoutException catch (e) {
      MyApplication.showToastView(message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    } on SocketException catch (e) {
      MyApplication.showToastView(message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print(e);
        MyApplication.showToastView(message: e.toString());
      }
    }
    return null;
  }
}
