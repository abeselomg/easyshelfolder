import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_shelf/authapi/api.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/profile/profilescreen.dart';
import 'package:easy_shelf/resource/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:easy_shelf/profile/profileform.dart';
// import '../home_page.dart';
import 'package:google_fonts/google_fonts.dart';

enum LoginViewState { PhoneNumberShown, PinShown }

class LoginPageOtp extends StatefulWidget {
  @override
  _LoginPageOtpState createState() => _LoginPageOtpState();
}

class _LoginPageOtpState extends State<LoginPageOtp> {
  final GlobalKey<FormState> _formdriverLoginKey = GlobalKey<FormState>();
  TextEditingController _pinController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  LoginViewState _loginViewState = LoginViewState.PhoneNumberShown;
  AuthAPI authAPI = new AuthAPI();

  PinDecoration _pinDecoration = UnderlineDecoration(
    enteredColor: Colors.black54,
    gapSpace: 5,
    color: Colors.black54.withOpacity(0.2),
  );
  String phoneNumber;
  String _errorPhoneMessage = "";
  bool isPhoneNumberValid, isCodeSent, isUserValid, isPinValid;
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 60;
  String countryCode;
  String countryName;
  int currentSeconds = 0;
  bool _checkUser = false;
  bool loading = true;
  var router;
  SmsReceiver receiver = new SmsReceiver();

  @override
  void initState() {
    countryCode = '+251';
    countryName = 'ET';
    checkUserSignedIn();
    initBool();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      if (!mounted) return;
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  Widget _title() {
    return Image.asset("assets/images/shelf.png",
        width: 130, height: 130, gaplessPlayback: false, fit: BoxFit.fill);
  }

  userBalance() {
    loading
        ? Container(
            child: CircularProgressIndicator(
            backgroundColor: Colors.black54,
          ))
        : Container();
    authAPI.getUser().then((value) => {
       authAPI.getUserBalance().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('balance', value['user']['wallet']['balance']);
      prefs.setString('activebalance', value['active_balance']);
      prefs.setString('pendingbalance', value['pending_balance']);
      var profilevalue = prefs.getBool("completeprofile");

      profilevalue == false
          ? Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  ProfileFormPage(0, value['user']['wallet']['balance'],value['active_balance'],value['pending_balance'])))
          :

          // String uid = prefs.getString('uid');
          print(value);
      print(value['user']['wallet']['balance']);

      print(value['active_balance']);
      print(value['pending_balance']);

      if (value != null) {
        setState(() {
          loading = false;
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => Profile(
              activeBalance: value['active_balance'],
              pendingBalance: value['pending_balance'],
              balance: value['active_balance'],
              user: UserData(
                  1,
                  "+251923805630",
                  "abeselom@email.com",
                  "251923805630",
                  "+251",
                  "Ethiopia",
                  "this.password",
                  null,
                  null)),
        ));
      } else {}
    })
    });
  }

  checkUserSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String uid = prefs.getString('uid');

    if (token != null) {
      userBalance();
    } else {
      receiver.onSmsReceived.listen((SmsMessage msg) {
        print("msgmsgmsgmsgmsgmsgmsgmsgmsgmsg ${msg.toMap}");
        if (msg.address == "easy") {
          setState(() {
            _pinController.text = msg.body.split(" ")[5];
          });
          onPhoneCodeSubmit();
        }
      });
      setState(() {
        _checkUser = true;
      });
    }
  }

  void initBool() {
    isPhoneNumberValid = true;
    isCodeSent = false;
    isUserValid = true;
    isPinValid = true;
  }

  Future<void> onPhoneNumberSubmit(String value) async {
    if (value.isNotEmpty) {
      _sendCodeToPhoneNumber();
    }
  }

  void onPhoneCodeSubmit() {
    if (_pinController.text.isNotEmpty) {
      _checkPinCode();
    }
  }

  void onResendCodeTap() {
    resentCode();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: _checkUser
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Text("EASY Mob",style: TextStyle(fontSize: 30),),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Expanded(
                          //   flex: 3,
                          //   child: SizedBox(),
                          // ),
                          _title(),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Sign in",
                              style: GoogleFonts.portLligatSans(
                                textStyle: Theme.of(context).textTheme.display1,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(44, 149, 121, 1.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 35,
                  ),
                  // ******************************** Design of TextFormField Widget ******************************//
                  Form(
                    key: _formdriverLoginKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: _loginViewState == LoginViewState.PhoneNumberShown
                          ? buildPhoneNumberTextField(mediaQuery)
                          : buildPinCodeTextField(mediaQuery),
                    ),
                  ),
                  isCodeSent
                      ? Text(
                          "Loading.....",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      : RaisedButton(
                          onPressed:
                              _loginViewState == LoginViewState.PhoneNumberShown
                                  ? _sendCodeToPhoneNumber
                                  : _checkPinCode,
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Color(0xFF1EB998),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            // side: BorderSide(color: Colors.red)
                          ),
                        )
                ],
              )
            : Container(
                child: CircularProgressIndicator(
                backgroundColor: Colors.black54,
              )),
      ),
    );
  }

  Widget buildPhoneNumberTextField(MediaQueryData medialQuery) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 6.0,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CountryCodePicker(
                    textStyle: TextStyle(fontSize: 16),
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
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.6,
                height: 60,
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 16),
                  autofocus: false,
                  maxLength: 9,
                  decoration: new InputDecoration(
                    hintText: 'Phone',
                  ),
                  controller: _phoneNumberController,
                  validator: (value) {
                    return !isPhoneNumberValid ? "Invalid Phone Length" : null;
                  },

                  onChanged: (text) {
                    validatePhoneNumber(text);
                  },
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      onPhoneNumberSubmit(value);
                    }
                  },
                  //        onSaved: (value) => _phone = value.trim(),
                ),
              )
            ],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.only(left: 15),
        //   height: 100,
        //   width: medialQuery.size.width - 100,
        //   child: TextFormField(
        //     controller: _phoneNumberController,
        //     keyboardType: TextInputType.phone,
        //     textInputAction: TextInputAction.go,
        //     autocorrect: false,
        //     maxLengthEnforced: true,
        //     validator: (value) {
        //       return !isPhoneNumberValid
        //           ? "Invalid Phone Length"
        //           : null;
        //     },
        //     onChanged: (text) {
        //       validatePhoneNumber(text);
        //     },
        //     onFieldSubmitted: (value) {
        //       if (value.isNotEmpty) {
        //         onPhoneNumberSubmit(value);
        //       }
        //     },
        //     style: TextStyle(color: Colors.black),
        //     decoration: new InputDecoration(
        //       labelText:"Phone Number",
        //       labelStyle: TextStyle(fontSize:  18),
        //       contentPadding: EdgeInsets.all(10),
        //       prefix: Container(
        //         padding: EdgeInsets.all(4.0),
        //         child: Text(
        //           "+251",
        //           style: TextStyle(
        //               color: Colors.black, fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        Padding(padding: EdgeInsets.only(bottom: 10)),
      ],
    );
  }

  Widget buildPinCodeTextField(MediaQueryData medialQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text("PIN has been sent to $phoneNumber"),
        ),
        Container(
          width: medialQuery.size.width - 100,
          height: 60,
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 24, right: 16),
            child: Column(
              children: <Widget>[
                Center(
                  child: PinInputTextField(
                    pinLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: _pinDecoration,
                    controller: _pinController,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      if (text.length == 6) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        onPhoneCodeSubmit();
                      }
                    },
                    onSubmit: (pin) {
                      if (pin.length == 6) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        onPhoneCodeSubmit();
                      } else {
                        // AppTranslations.of(context).text("type_Verification_code");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        !isPhoneNumberValid || !isUserValid || !isPinValid
            ? Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  _errorPhoneMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
            : SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            (((timerMaxSeconds - currentSeconds) % 60) == 0 ||
                    timerMaxSeconds != 60)
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: FlatButton(
                        onPressed: onResendCodeTap, child: Text("resend pin")),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: FlatButton(
                        onPressed: onResendCodeTap, child: Text(timerText)),
                  ),
            new Padding(padding: new EdgeInsets.only(left: 20, top: 15.0)),
            // Center(
            //   child: isCodeSent ? CircularProgressIndicator() : SizedBox(),
            // ),
          ],
        ),
      ],
    );
  }

  Future _sendCodeToPhoneNumber() async {
    if ((await validatePhoneNumberAfter())) {
      await startTimeout();
      final formState = _formdriverLoginKey.currentState;
      if (formState.validate()) {
        setState(() {
          phoneNumber =
              "+251" + _phoneNumberController.text.replaceAll(" ", "");
          _loginViewState = LoginViewState.PinShown;
        });

        await authAPI.sendVerificationCode(phoneNumber);
      }
    } else {
      setState(() {
        isPhoneNumberValid = false;
        _errorPhoneMessage = "Fill PhoneNumber";
      });
    }
  }

  Future _checkPinCode() async {
    final formState = _formdriverLoginKey.currentState;
    if (formState.validate()) {
      setState(() {
        isCodeSent = true;
        isPinValid = true;
      });
      await authAPI
          .verifyCode(_pinController.text, phoneNumber)
          .then((response) async {
        if (response == 200) {
          await authAPI.getUser().then((value) {
            print("****************user data**************");
            print(value);
            userBalance();
          });
        } else {
          setState(() {
            _errorPhoneMessage = "Invalid PIN Number";
            isCodeSent = false;
            isPinValid = false;
          });
        }
      });
    }
  }

  void resentCode() {
    setState(() {
      _loginViewState = LoginViewState.PhoneNumberShown;
      isCodeSent = false;
      isUserValid = true;
      isPinValid = true;
      isPhoneNumberValid = true;
      _pinController.clear();
    });
  }

  bool validatePhoneNumber(String text) {
    Pattern pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regex = new RegExp(pattern);
    if (text.isNotEmpty && (text.length > 9)) {
      setState(() {
        isPhoneNumberValid = false;
      });
      return false;
    }
    if (_phoneNumberController.text.isNotEmpty) {
      if (!regex.hasMatch(text)) {
        setState(() {
          isPhoneNumberValid = false;
        });
        return false;
      }
    }
    setState(() {
      isPhoneNumberValid = true;
    });
    return true;
  }

  bool validatePhoneNumberAfter() {
    Pattern pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        isPhoneNumberValid = true;
        _errorPhoneMessage = "Fill Phone Number";
      });
      return false;
    } else {
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(_phoneNumberController.text)) {
        setState(() {
          isPhoneNumberValid = true;
          _errorPhoneMessage = "Enter Valid Phone Number";
        });
        return false;
      } else {
        return true;
      }
    }
  }
}
