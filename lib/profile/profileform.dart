import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_shelf/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:easy_shelf/profile/profileform.dart';
import 'package:easy_shelf/profile/profilescreen.dart';
import 'package:easy_shelf/views/home.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:shared_preferences/shared_preferences.dart';
// import 'ResetPass.dart';
// import 'Signup.dart';

class FormData {
  String email;
  String password;

  FormData(this.email, this.password);

  FormData.fromJson(Map<String, dynamic> json)
      : email = json['email_or_phone'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'email_or_phone': email,
        'password': password,
      };
}

// Define a custom Form widget.
class ProfileFormPage extends StatefulWidget with NavigationStates {
  final int type;
  final String balance;
  final String activebalance;
  final String pendingbalance;

  ProfileFormPage(this.type,this.balance,this.activebalance,this.pendingbalance);
  @override
  _ProfileFormPage createState() => _ProfileFormPage(this.type,this.balance,this.activebalance,this.pendingbalance);
}

class _ProfileFormPage extends State<ProfileFormPage> {
  final int type;
  final String balance;
  final String activebalance;
  final String pendingbalance;

  _ProfileFormPage(this.type,this.balance,this.activebalance,this.pendingbalance);
  var loggedIn = false;
  Constants constants = Constants();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController phoneInputController;
  TextEditingController passInputController;
  TextEditingController codeInputController;
  TextEditingController emailInputController;
  TextEditingController fnameInputController;
  TextEditingController lnameInputController;

  var _pressed;
  String countryCode, countryName;
  SharedPref sharedPref = SharedPref();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ProgressDialog progressDialog;
  bool countDown = false;

  @override
  initState() {
    countryCode = '+251';
    countryName = 'ET';
    _pressed = false;
    phoneInputController = new TextEditingController();
    passInputController = new TextEditingController();
    codeInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    fnameInputController = new TextEditingController();
    lnameInputController = new TextEditingController();
    super.initState();
  }

  Future<bool> loginUser(BuildContext context) async {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMMMMd('en_US');
    var timeFormatter = new DateFormat.jm();
    String formattedDate = formatter.format(now);
    String formattedTime = timeFormatter.format(now);
    // Navigator.pushReplacement(
    // context, MaterialPageRoute(builder: (BuildContext context) => ProfileFormPage(
    //      )));

    sharedPref.setLoggedIn('logged', true);
    // if(this.type == 1){
    //   FormData data = FormData(phoneInputController.text,passInputController.text);
    //   _userLogin(jsonEncode(data))
    //   .then((value) async {

    //     if(value['status'] == 200){
    //       value = jsonDecode(value['body']);
    //       UserData userData = UserData(
    //           value['user']['id'],
    //           value['user']['username'],
    //           value['user']['email'],
    //           value['user']['phone'],
    //           value['user']['code'],
    //           countryName,
    //           passInputController.text,
    //           null,null);
    //       sharedPref.save('user',jsonEncode(userData).toString());
    //       sharedPref.setLoggedIn('isLoggedIn',true);
    //       // Navigator.of(context, rootNavigator: true).pop();
    //       if (progressDialog.isShowing())
    //         progressDialog.hide().then((isHidden) {
    //           bl.BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
    //         });
    //     }else if (value['status'] == 422){
    //       if (progressDialog.isShowing())
    //         progressDialog.hide().then((isHidden) {
    //           showDialog(
    //               context: context,
    //               barrierDismissible: false,
    //               builder: ((context) {
    //                 return AlertDialog(
    //                   title: Text("Error"),
    //                   content: Text(jsonDecode(value['body'])['message'].toString()),
    //                   actions: <Widget>[
    //                     FlatButton(
    //                         onPressed: () {
    //                           Navigator.of(context, rootNavigator: true).pop();
    //                         },
    //                         child: Text("OK")
    //                     )
    //                   ],
    //                 );
    //               })
    //           );
    //         });
    //     }

    //   });
    // }
    // else {
    //   FormData data = FormData(emailInputController.text,passInputController.text);
    //   _userLogin(jsonEncode(data)).then((value) async {
    //     print(value);
    //     if(value['status'] == 200){
    //       value = jsonDecode(value['body']);
    //       UserData userData = UserData(
    //           value['user']['id'],
    //           value['user']['username'],
    //           value['user']['email'],
    //           value['user']['phone'],
    //           value['user']['code'],
    //           countryName,
    //           passInputController.text,
    //           null,null);
    //       sharedPref.save('user',jsonEncode(userData).toString());
    //       sharedPref.setLoggedIn('isLoggedIn',true);
    //       // Navigator.of(context, rootNavigator: true).pop();
    //       if (progressDialog.isShowing())
    //         progressDialog.hide().then((isHidden) {
    //           Navigator.of(context).pushAndRemoveUntil(
    //               MaterialPageRoute(
    //                   builder: (context) => MyHomePage()
    //               ), (Route<dynamic> route) => false);
    //         });
    //     }else if (value['status'] == 422){
    //       if (progressDialog.isShowing())
    //         progressDialog.hide().then((isHidden) {
    //           showDialog(
    //               context: context,
    //               barrierDismissible: false,
    //               builder: ((context) {
    //                 return AlertDialog(
    //                   title: Text("Error"),
    //                   content: Text(jsonDecode(value['body'])['message'].toString()),
    //                   actions: <Widget>[
    //                     FlatButton(
    //                         onPressed: () {
    //                           Navigator.of(context, rootNavigator: true).pop();
    //                         },
    //                         child: Text("OK")
    //                     )
    //                   ],
    //                 );
    //               })
    //           );
    //         });
    //     }
    //     else {
    //       if (progressDialog.isShowing())
    //         progressDialog.hide().then((isHidden) {
    //           showDialog(
    //               context: context,
    //               barrierDismissible: false,
    //               builder: ((context) {
    //                 return AlertDialog(
    //                   title: Text("Error"),
    //                   content: Text("Something Went Wrong Please Try Again"),
    //                   actions: <Widget>[
    //                     FlatButton(
    //                         onPressed: () {
    //                           Navigator.of(context, rootNavigator: true).pop();
    //                         },
    //                         child: Text("OK")
    //                     )
    //                   ],
    //                 );
    //               })
    //           );
    //         });
    //     }
    //   });
    // }
    return true;
  }

  Future<Map<dynamic, dynamic>> _userLogin(String data) async {
    String url = urlSt + '/api/v1/api_login';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String json = data;
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    return {"body": body, "status": statusCode};
  }

  Widget _title() {
    return Image.asset("assets/images/shelf.png",
        width: 130, height: 130, gaplessPlayback: false, fit: BoxFit.fill);
  }

  Future sendVerificationCode(String phoneNumber) async {
    Map<String, dynamic> body = {"phoneNumber": phoneNumber};

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
    };

    try {
      return await post(Uri.encodeFull(urlSt + "/auth/send-verification-code"),
              headers: headers, body: json.encode(body))
          .then((Response response) async {
        final int statusCode = response.statusCode;
        print(
            "*************************** sendVerificationCode ${response.statusCode}***********************************");
        if (response.statusCode == 202) {
          print("Success");
        }
        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error while fetching data");
        }
        return statusCode;
      });
    } catch (Exception, s) {
      print("Error AuthAPI sendVerificationCode : ${Exception.toString()}");
    }
  }

  Future<void> onPhoneNumberSubmit(String value) async {
    if (value.isNotEmpty) {
      // _sendCodeToPhoneNumber();
      var phoneNumber = "+251" + value;
      await sendVerificationCode(phoneNumber);
    }
  }

  Widget showPhoneInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 7.5,
              height: 60,
              child: CountryCodePicker(
                showFlag: false,
                showFlagDialog: true,
                onChanged: (c) {
                  setState(() {
                    countryCode = c.toString();
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              height: 60,
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.phone,
                autofocus: false,
                maxLength: 10,
                decoration: new InputDecoration(hintText: 'Phone'),
                controller: phoneInputController,
                validator: phoneValidator,
                //        onSaved: (value) => _phone = value.trim(),
              ),
            )
          ],
        ));
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
    } else if (value.length < 6) {
      return 'Password too short';
    } else {
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
      child: InkWell(
        onTap: () async {
          if (_loginFormKey.currentState.validate()) {
            progressDialog.show();
            final SharedPreferences pref = await _prefs;

            pref.setBool("completeprofile", true);
            progressDialog.hide();

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Profile(balance: balance,activeBalance: activebalance,pendingBalance: pendingbalance,
                    user: UserData(
                      
                        1,
                        "+251923805630",
                        "abeselom@email.com",
                        "251923805630",
                        "+251",
                        "Ethiopia",
                        "this.password",
                        null,
                        null))));
          } else {
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
            'Submit',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              'Register',
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

  void initiateSignIn(String type) {
    _handleSignIn(type).then((result) {
      if (result == 1) {
        setState(() {
          loggedIn = true;
        });
      } else {}
    });
  }

  Future<int> _handleSignIn(String type) async {
    return 1;
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: emailValidator,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        controller: emailInputController,
//        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showLnameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (value) {
          if (value == null) {
            return "Input cannot be null";
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: 'Last Name',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        controller: lnameInputController,
//        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showFnameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (value) {
          if (value == null) {
            return "Input cannot be null";
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: 'First Name',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        controller: fnameInputController,
//        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  String emailValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'Email can\'t be empty';
    } else if (!validateEmail(value)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Widget showVerificationInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 6.7,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CountryCodePicker(
                  showFlag: true,
                  onChanged: (c) {
                    setState(() {
                      countryCode = c.toString();
                    });
                  },
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  initialSelection: 'ET',
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
                maxLength: 9,
                decoration: new InputDecoration(hintText: 'Phone'),
                controller: codeInputController,
                validator: verificationValidator,
                //        onSaved: (value) => _phone = value.trim(),
              ),
            )
          ],
        ));
  }

  String verificationValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'code can\'t be empty';
    } else if (value.length < 6) {
      return 'Invalid code entered';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height,
                child: Form(
//            height: MediaQuery.of(context).size.height,
                  key: _loginFormKey,
                  autovalidate: _autoValidate,
                  child: !countDown
                      ? Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(),
                                  ),
                                  _title(),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: "Complete your Profile",
                                      style: GoogleFonts.portLligatSans(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .display1,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            Color.fromRGBO(44, 149, 121, 1.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  // showEmailInput(),
                                  // showPhoneInput(),
                                  showFnameInput(),
                                  showLnameInput(),
                                  showEmailInput(),

                                  // if(this.type == 0)
                                  // showPasswordInput(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _submitButton(),

                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ),

//                  Positioned(top: 40, left: 0, child: _backButton()),
//                Positioned(
//                    top: -MediaQuery.of(context).size.height * .15,
//                    right: -MediaQuery.of(context).size.width * .4,
//                    child: BezierContainer())
                          ],
                        )
                      : Stack(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(),
                                    ),
                                    _title(),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: this.type == 0
                                            ? "Login by Email"
                                            : "Login by Phone",
                                        style: GoogleFonts.portLligatSans(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .display1,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromRGBO(44, 149, 121, 1.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ))
                          ],
                        ),
                ))));
  }
}
