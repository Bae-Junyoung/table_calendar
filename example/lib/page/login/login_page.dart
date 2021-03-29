// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import '../../ui/colors.dart';
import 'kakao_login.dart';
import 'naver_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      setState(() {
        //Redraw so that the username label reflects the focus state
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        //Redraw so that the password label reflects the focus state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 48.0),
          children: <Widget>[
            SizedBox(height: 60.0),
            Column(
              children: <Widget>[
                Icon(
                  Icons.local_drink_outlined,
                  size: 80,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Doljago',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            SizedBox(height: 60.0),
            // [Name]
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                labelStyle: TextStyle(
                    color: _usernameFocusNode.hasFocus
                        ? Theme.of(context).accentColor
                        : _unfocusedColor),
              ),
              focusNode: _usernameFocusNode,
            ),

            // spacer
            SizedBox(height: 12.0),
            // [Password]
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: _passwordFocusNode.hasFocus
                        ? Theme.of(context).accentColor
                        : _unfocusedColor),
              ),
              focusNode: _passwordFocusNode,
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    // TODO: 회원가입
                    print('회원가입');
                  },
                ),
                FlatButton(
                  child: Text(
                    '취소',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  color: Colors.black87,
                  child: Text(
                    '로그인',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  elevation: 8.0,
                  // New code
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/main_page');
                  },
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => KakaoLoginScreen(),
                ),
              ),
              child:
                  makeImage('assets/login_button/kakao_login_medium_wide.png'),
            ),
            SizedBox(height: 12,),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NaverLoginScreen(),
                ),
              ),
              child: makeImage('assets/login_button/naver_login_green.png'),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeImage(String path) {
    return Container(
      child: Image.asset(path, width: 500, height: 50, fit: BoxFit.fill),
      padding: EdgeInsets.only(left: 2, right: 2, bottom: 1),
    );
  }
}
