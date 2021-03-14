import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import kakao sdk
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:kakao_flutter_sdk/common.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();

  }

  @override
  void dispose() {
    super.dispose();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  bool _isKakaoTalkInstalled = true;

  _issueAccessToken(String authCode) async {
    print(authCode);
    try {
      AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print('_issueAccessToken');
      print(token.toJson());
      Navigator.pushNamed(context, '/main_page');
    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // KaKao native app key
    KakaoContext.clientId = '9f8adcb91ab6469d6fc8ee3bfce53d70';
    // KaKao javascript key
    KakaoContext.javascriptClientId = "292cb29e49e6d171294828ccc6100afd";

    isKakaoTalkInstalled();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Flutter SDK Login"),
        actions: [],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          RaisedButton(child: Text("Login"), onPressed: _checkAccessToken),
          RaisedButton(
              child: Text("Login with Talk"),
              onPressed: _isKakaoTalkInstalled ? _loginWithTalk : null),
          RaisedButton(child: Text("check token"), onPressed: _accessTokenInfo),

        ],
      )),
    );
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
      print('_loginWithKakao');
      print(code);
    } on KakaoAuthException catch (e) {
      print(e);
      // some error happened during the course of user login... deal with it.
    } on KakaoClientException catch (e) {
      print(e);
      //
    } catch (e) {
      print(e);
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
      print('_loginWithTalk');
      print(code);
    } on KakaoAuthException catch (e) {
      print(e);
      // some error happened during the course of user login... deal with it.
    } on KakaoClientException catch (e) {
      print(e);
      //
    } catch (e) {
      print(e);
    }
  }
  Future<String> _checkAccessToken() async {
    var token = await AccessTokenStore.instance.fromStore();
    debugPrint(token.toString());
    if (token.refreshToken == null) {
      // Navigator.of(context).pushReplacementNamed('/login');
      _loginWithKakao();
    } else {
      // Navigator.of(context).pushReplacementNamed("/main");
      // _loginWithKakao();
      print(token.refreshToken);
      Navigator.pushNamed(context, '/login_result');
    }
  }
  _showAddDialog(String text) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white70,
          title: Text(text),
        ));
  }
  Future _accessTokenInfo() async {
    // print(await UserApi.instance.me());
    try {
      var info = await UserApi.instance.accessTokenInfo();
      print(info.toJson());
    } catch(e) {
      print(e);
    }
  }
}
