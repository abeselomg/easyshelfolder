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
import 'package:easy_shelf/views/login_page.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

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
class DepositFormPage extends StatefulWidget with NavigationStates {
  final int type;
  final String account;
  final String bankname;
  final String image;
  final String contactname;
  final String contactnumber;

  DepositFormPage(this.type, this.account, this.bankname, this.image,
      this.contactname, this.contactnumber);
  @override
  _DepositFormPage createState() => _DepositFormPage(this.type, this.account,
      this.bankname, this.image, this.contactname, this.contactnumber);
}

class _DepositFormPage extends State<DepositFormPage> {
  final int type;
  final String account;
  final String bankname;
  final String image;
  final String contactname;
  final String contactnumber;

  _DepositFormPage(this.type, this.account, this.bankname, this.image,
      this.contactname, this.contactnumber);
  var loggedIn = false;
  Constants constants = Constants();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: const Duration(seconds: 2), content: new Text(value)));
  }

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
  bool amountcomplete = false;
  bool picturecomplete = false;
  File _image;
  final picker = ImagePicker();
  dynamic pickedFile;
  bool butloader = false;
  String _character = 'Camera';
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
    // context, MaterialPageRoute(builder: (BuildContext context) => DepositFormPage(
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
    return Column(
      children: [
        Image.network("$image",
            width: 130, height: 130, gaplessPlayback: false, fit: BoxFit.fill),
        SizedBox(
          height: 20,
        ),
        Text(bankname),
        SizedBox(
          height: 5,
        ),
        Text(account),
        SizedBox(
          height: 30,
        ),
        Text(contactname),
        SizedBox(
          height: 5,
        ),
        Text(contactnumber),
      ],
    );
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

  Widget showPhoneInput(context) {
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

  Widget _submitButton(context) {
    progressDialog = ProgressDialog(
      context,
    );
    progressDialog.style(
      message: "Please Wait....",
    );
    return Material(
      child: InkWell(
        onTap: () async {
          if (pickedFile == null ||
              fnameInputController.text == '' ||
              fnameInputController.text == null) {
            // progressDialog.show();
            final SharedPreferences pref = await _prefs;
            setState(() {
              // _autoValidate = true;
              amountcomplete = true;
              picturecomplete = true;
            });

            // pref.setBool("completeprofile", true);
            // progressDialog.hide();

            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //     builder: (BuildContext context) => Profile(
            //         user: UserData(
            //             1,
            //             "+251923805630",
            //             "abeselom@email.com",
            //             "251923805630",
            //             "+251",
            //             "Ethiopia",
            //             "this.password",
            //             null,
            //             null))));
          } else {
            setState(() {
              butloader = true;
            });
            print('value');
            print(fnameInputController.text);
            print(pickedFile);
            await sendImage(pickedFile, context);
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
          child: butloader
              ? Text(
                  'Loading...',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              : Text(
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
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) {
          if (value == null) {
            return "Input cannot be null";
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: 'Amount',
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

  Widget showVerificationInput(context) {
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
    Future getImage() async {
      // _showFormDialog(context);
      if (_character=='Camera') {
         pickedFile = await picker.getImage(
          source: ImageSource.camera, maxHeight: 500, maxWidth: 500);
      } else {
         pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
      }
     

      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("Success");
        print(_image);
        var base64Image = base64Encode(_image.readAsBytesSync());
        print(base64Image);
      } else {
        print('No image selected.');
      }
    }

    _showFormDialog(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (param) {
            return AlertDialog(
              actions: <Widget>[
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"));
                }),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage();
                      },
                      child: Text("Select"));
                })
              ],
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    ListTile(
                      title: const Text('Camera'),
                      leading: Radio(
                        value: 'Camera',
                        groupValue: _character,
                        onChanged: (value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Gallery'),
                      leading: Radio(
                        value: 'Gallery',
                        groupValue: _character,
                        onChanged: (value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ]
                      // List<Widget>.generate(4, (int index) {
                      //   return Radio<int>(
                      //     value: index,
                      //     groupValue: selectedRadio,
                      //     onChanged: (int value) {
                      //       setState(() => selectedRadio = value);
                      //     },
                      //   );
                      // }),

                      );
                },
              ),
            );
          });
    }

    return Scaffold(
        key: scaffoldKey,
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
                                  // RichText(
                                  //   textAlign: TextAlign.center,
                                  //   text: TextSpan(
                                  //     text: "Complete your Profile",
                                  //     style: GoogleFonts.portLligatSans(
                                  //       textStyle: Theme.of(context)
                                  //           .textTheme
                                  //           .display1,
                                  //       fontSize: 30,
                                  //       fontWeight: FontWeight.w700,
                                  //       color:
                                  //           Color.fromRGBO(44, 149, 121, 1.0),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 25,
                                  // ),
                                  // showEmailInput(),
                                  // showPhoneInput(),
                                  showFnameInput(),
                                  amountcomplete
                                      ? Text(
                                          "please Enter an amount",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text(''),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TextButton(
                                        child: Text('Upload Image'),
                                        onPressed: () {
                                          _showFormDialog(context);
                                        },
                                      ),
                                    ),
                                  ),

                                  picturecomplete
                                      ? Text(
                                          "please select an Image",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text(''),
                                  // showLnameInput(),
                                  // showEmailInput(),

                                  // if(this.type == 0)
                                  // showPasswordInput(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _submitButton(context),

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

  Future sendImage(PickedFile pickedFile, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String uid = prefs.getString('uid');
    var stream =
        new http.ByteStream(DelegatingStream.typed(pickedFile.openRead()));
    // get file length
    var length = await _image.length();
    ; //imageFile is your image file
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    }; // ignore this headers if there is no authentication

    // string to uri
    var uri = Uri.parse("https://easypayet.xyz/api/v1/users/deposit");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    print(account);
    print(bankname);
    print(image);
    print(contactname);
    print(contactnumber);

    // multipart that takes file
    var multipartFileSign = new http.MultipartFile('screenshot', stream, length,
        filename: basename(pickedFile.path));

    // add file to multipart
    request.files.add(multipartFileSign);

    //add headers
    request.headers.addAll(headers);

    //adding params
    request.fields['amount'] = fnameInputController.text;
    request.fields['deposit_account'] = account;
    request.fields['sub'] = uid;

    // send
    var response = await request.send();
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    var balancer = prefs.getString('balance');
    print("******************* 200 *******************");
    if (response.statusCode == 200) {
      showInSnackBar('Deposit Successful');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPageOtp()));
    } else {
      setState(() {
        butloader = false;
      });
      showInSnackBar('Something happened.Please try again');
    }

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
