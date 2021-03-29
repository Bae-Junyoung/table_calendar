//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:http/http.dart' as http;
import 'page/login/kakao_login.dart';
import 'page/login/kakao_login_result.dart';
import 'model/cafe_info_post.dart';
import 'page/login/login_page.dart';
import 'dart:async';

import 'page/main_page.dart';

// Example holidays
//

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Table Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/main_page": (context) => HomePage(
              title: 'doljago',
            ),
        "/login_result": (context) => KakaoLoginResult(),
      },
      // home: LoginPage()
    );
  }
}
