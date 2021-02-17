import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:easy_shelf/helpers/PostData.dart';
import '../helpers/sharedPref.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'MainApp.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String countryCode;
  String countryName;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController codeInputController;
  TextEditingController passInputController;
  TextEditingController confirmpassInputController;
  var _pressed;
  SharedPref sharedPref = SharedPref();
  ProgressDialog progressDialog;
  @override
  initState() {
    _pressed = true;
    countryCode = "+251";
    countryName = "ET";
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    passInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    codeInputController = new TextEditingController();
    confirmpassInputController = new TextEditingController();
    super.initState();
  }

  Future<bool> registerUser(BuildContext context) async {
    PostData data = PostData(
        firstNameInputController.text,lastNameInputController.text,emailInputController.text,
        phoneInputController.text,countryCode,passInputController.text);
    var now = new DateTime.now();
    var formatter = new DateFormat.yMMMMd('en_US');
    var timeFormatter = new DateFormat.jm();
    String formattedDate = formatter.format(now);
    String formattedTime = timeFormatter.format(now);
    _userRegistration(jsonEncode(data)).then((value) async {
      print(value);
      if(value['status'] == 200){
        value = jsonDecode(value['body']);
        if(value["errors"] == null){
          UserData userData = UserData(
              value['user']['id'],
              value['user']['username'],
              value['user']['email'],
              value['user']['phone'],
              value['user']['code'],
              countryName,
              passInputController.text,
              null,null);
          sharedPref.save('user',jsonEncode(userData).toString());
          sharedPref.setLoggedIn('isLoggedIn',true);
          // Navigator.of(context, rootNavigator: true).pop();
          if (progressDialog.isShowing())
            progressDialog.hide().then((isHidden) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => MyHomePage()
                  ), (Route<dynamic> route) => false);
            });
        }else{
            if (progressDialog.isShowing())
              progressDialog.hide().then((isHidden) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: ((context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text(value['errors'].toString()),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Text("OK")
                          )
                        ],
                      );
                    })
                );
              });
        }
      }else if (value['status'] == 422){
        if (progressDialog.isShowing())
          progressDialog.hide().then((isHidden) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: ((context) {
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text(jsonDecode(value['body'])['message'].toString()),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text("OK")
                      )
                    ],
                  );
                })
            );
          });
      }
    });
    return true;
  }

  Future<Map<dynamic,dynamic>> _userRegistration(String data) async {
    String url = urlSt+'/api/v1/api_register';
    Map<String, String> headers = {"Content-type": "application/json","Accept": "application/json"};
    String json = data;
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    return {"status" : statusCode, "body" : body};
  }


  Widget showFNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'First Name',
            icon: new Icon(
              Icons.account_circle,
              color: Colors.grey,
            )),
        controller: firstNameInputController,
        validator: (value) =>
        value.isEmpty ? 'First Name can\'t be empty' : null,
//        onSaved: (value) => _fname = value.trim(),
      ),
    );
  }

  Widget showLNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Last Name',
            icon: new Icon(
              Icons.account_circle,
              color: Colors.grey,
            )),
        controller: lastNameInputController,
        validator: (value) =>
        value.isEmpty ? 'Last Name can\'t be empty' : null,
//        onSaved: (value) => _lname = value.trim(),
      ),
    );
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 3.5,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CountryCodePicker(
                onChanged: (c){
                  setState(() {
                    countryCode = c.toString();
                    countryName = c.code;
                  });
                },
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                initialSelection: countryName,
                alignLeft: true,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
            child: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.phone,
              autofocus: false,
              maxLength: 10,
              decoration: new InputDecoration(
                  hintText: 'Phone'
              ),
              controller: phoneInputController,
              validator: phoneValidator,
  //        onSaved: (value) => _phone = value.trim(),
            ),
          )
        ],
      )
    );
  }

  String phoneValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'Phone can\'t be empty';
    } else if (value.length < 9) {
      return 'Invalid phone entered';
    } else {
      return null;
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email (optional)',
            icon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        controller: emailInputController,
//        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        controller: passInputController,
        validator: passValidator,
//        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  String passValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'Password can\'t be empty';
    } else if (value.length < 6){
      return 'Password too short';
    }else{
      return null;
    }
  }

  Widget showConfirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Confirm Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        controller: confirmpassInputController,
        validator: confirmPassValidator,
//        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  String confirmPassValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'ConfirmPassword can\'t be empty';
    } else if (value.length < 6){
      return 'ConfirmPassword too short';
    }else if (value != passInputController.text){
      return 'Password do not match!';
    }else{
      return null;
    }
  }

  Widget _submitButton() {
    progressDialog = ProgressDialog(
      context,
    );
    progressDialog.style(
      message: "Please Wait....",
    );
      return Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            if (_registerFormKey.currentState.validate()) {
              progressDialog.show();
              registerUser(context);
            }else{
              setState(() {
                _autoValidate = true;
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                color: Color.fromRGBO(44, 149, 121, 1.0)),
            child: Text(
              'Register Now',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainAppPage(page: 2,)));
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color.fromRGBO(44, 149, 121, 1.0),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return Image.asset("assets/logo.png",
        width: 130,
        height: 130,
        gaplessPlayback: false,
        fit: BoxFit.fill
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _registerFormKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _title(),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Register',
                                        style: GoogleFonts.portLligatSans(
                                          textStyle: Theme.of(context).textTheme.display1,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromRGBO(44, 149, 121, 1.0),
                                        ),),
                                    ),
                                    showFNameInput(),
                                    showLNameInput(),
                                    showPhoneInput(),
                                    showPasswordInput(),
                                    showConfirmPasswordInput(),
                                    showEmailInput(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    _submitButton(),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: _loginAccountLabel(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
            )
        ));
  }
}
