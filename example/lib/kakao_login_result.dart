import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';

// import kakao sdk
import 'package:kakao_flutter_sdk/user.dart';

class LoginResult extends StatefulWidget {
  @override
  _LoginResultState createState() => _LoginResultState();
}

class _LoginResultState extends State<LoginResult> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initTexts();
  }

  _initTexts() async {
    final User user = await UserApi.instance.me();

    print(
        "=========================[kakao account]=================================");
    print(user.kakaoAccount.toString());
    print(
        "=========================[kakao account]=================================");

    setState(() {
      _accountEmail = user.kakaoAccount.email;
      _ageRange = user.kakaoAccount.ageRange.toString();
      _gender = user.kakaoAccount.gender.toString();
      _birthDay = user.kakaoAccount.birthday.toString();
      _ci = user.kakaoAccount.ci.toString();
      _phoneNumber = user.kakaoAccount.phoneNumber.toString();
      _nickname = user.kakaoAccount.profile.nickname.toString();
      _profileImageUrl = user.kakaoAccount.profile.profileImageUrl==null?'None':user.kakaoAccount.profile.profileImageUrl.toString();
      // _thumbnailImageUrl =
      //     user.kakaoAccount.profile.thumbnailImageUrl.toString();
    });
  }

  String _accountEmail = 'None';
  String _ageRange = 'None';
  String _gender = 'None';
  String _birthDay = 'None';
  String _ci = 'None';
  String _phoneNumber = 'None';
  String _nickname = 'None';
  String _profileImageUrl = 'None';

  // String _thumbnailImageUrl = 'None';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("_accountEmail : $_accountEmail"),
              Text("_ageRange : $_ageRange"),
              Text("_gender : $_gender"),
              Text("_birthDay : $_birthDay"),
              Text("_ci : $_ci"),
              Text("_phoneNumber : $_phoneNumber"),
              Text("_profile : $_nickname"),
              Container(
                  width: 300,
                  height: 400,
                  child: _profileImageUrl=='None'?Text('None'):Image.network(_profileImageUrl)),
              // Container(
              //     width: 100,
              //     height: 100,
              //     child: Image.network(_thumbnailImageUrl)),
              RaisedButton(child: Text("goToLogin"), onPressed: (){
                Navigator.pushNamed(context, '/');
              }),
              RaisedButton(child: Text("accessTokenInfo"), onPressed: _accessTokenInfo),
              RaisedButton(child: Text("Logout"), onPressed: _logOutWithKakao),
              RaisedButton(child: Text("unlinkTalk"), onPressed: _unlinkTalk),
            ],
          ),
        ),
      ),
    );
  }

  Future _logOutWithKakao() async {
    try {
      var code = await UserApi.instance.logout();
      await AccessTokenStore.instance.clear();
      print(code.toJson());
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {
      print(e);
    }
  }
  Future _accessTokenInfo() async {
    try {
      var info = await UserApi.instance.accessTokenInfo();
      print(info.toJson());
    } catch(e) {
      print(e);
    }
  }
  Future _unlinkTalk() async {
    try {
      var code = await UserApi.instance.unlink();
      await AccessTokenStore.instance.clear();
      print(code.toJson());
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch(e){
      print(e);
    }
  }
}
