import 'dart:convert';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/helpers/TitleHead.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:easy_shelf/profile/constant.dart';
import 'package:easy_shelf/views/MainApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'first.dart';

class ChangePassPage extends StatefulWidget{
  final UserData user;

  ChangePassPage({@required this.user});

  @override
  _ChangePassPage createState() => _ChangePassPage(user: this.user);
}

class _ChangePassPage extends State<ChangePassPage> {
  final UserData user;
  _ChangePassPage({@required this.user});
  SharedPref sharedPref = SharedPref();
  TextEditingController passInputController, oldPassInputController;
  TextEditingController confirmpassInputController;
  var _pressed;
  final GlobalKey<FormState> _changePassFormKey = GlobalKey<FormState>();
  ProgressDialog progressDialog;
  String firstChoice;
  Future<Map<dynamic,dynamic>> _changePassword() async {
    String restStr = '/api/v1/users/profile/update/password';
    String url = urlSt+ restStr;
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey
    };
    Map<String,String> json;
      json = {
        "user_id": user.id.toString(),
        "old" : oldPassInputController.text,
        "password" : passInputController.text,
        "confirm_password" : confirmpassInputController.text,
      };
    Response response = await post(url, headers: headers,
      body: jsonEncode(json),
    );
    int statusCode = response.statusCode;
    String body = response.body;
    return jsonDecode(jsonEncode({
      'body' : jsonDecode(body),
      'status': statusCode,
    }));
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
          onTap: () {
            if (_changePassFormKey.currentState.validate()) {
              progressDialog.show();
              _changePassword().then((value) {
                print(value['body']);
                print(value['status']);
                if(value['status'] == 200){
                  if(progressDialog.isShowing())
                    progressDialog.hide().then((value) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text("Successfully Updated"),
                            content: Text("you will now automatically logout!"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    sharedPref.remove("isLoggedIn");
                                    sharedPref.remove("user");
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => MainAppPage(page: 2)
                                    ), (Route<dynamic> route) => false);
                                    // Navigator.pop(context);
                                  },
                                  child: Text("OK")
                              )
                            ],
                          );
                        }),
                      );
                    });
                }else if(value['status'] == 422){
                  if(progressDialog.isShowing())
                  progressDialog.hide().then((isHidden) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(value['body']['errors'].toString()),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  // Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text("OK")
                            )
                          ],
                        );
                      }),
                    );
                  });
                }else{
                  if(progressDialog.isShowing())
                    progressDialog.hide().then((isHidden) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("Something went wrong"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK")
                            )
                          ],
                        );
                      }),
                    );
                  });
                }
              });
            }else{
              if(progressDialog.isShowing())
                progressDialog.hide().then((isHidden) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: ((context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Something went wrong"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK")
                          )
                        ],
                      );
                    }),
                  );
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
              'Change',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      );
  }
  @override
  initState() {
    _pressed = true;
    oldPassInputController = new TextEditingController();
    passInputController = new TextEditingController();
    confirmpassInputController = new TextEditingController();
    super.initState();
  }

  Widget _title(String title) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title,
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color.fromRGBO(44, 149, 121, 1.0),
        ),),
    );
  }

  Widget showOldPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Old Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        controller: oldPassInputController,
        validator: oldPassValidator,
//        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  String oldPassValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'Old Password can\'t be empty';
    } else if (value.length < 6){
      return 'Old Password too short';
    }else{
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

  Widget _createAccountLabel() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Flexible(
              child: ListTile(
                title: Text(
                  'Be Warned',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900,color: Color.fromRGBO(41, 149, 121, 1.0)),
                ),
                subtitle: Text('The system will log you out once you change the password!',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child:
        firstChoice == null ?
        Container(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget> [
             TitleHead(
               icon: 'true',
               title: null,
               logo: 'assets/logo_small.png',
             ),
             SizedBox(
               height: 40,
             ),
             Container(
               decoration: new BoxDecoration(
                   color: Color.fromRGBO(44, 149, 121, 1.0)
               ),
               height: deviceSize.height * 0.05,
               child: new Center(
                 child: Text(
                   "Please Select One",
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),
             ),
             SizedBox(
               height: 20,
             ),
             Row(
               children: <Widget>[
                 Padding(
                   padding: EdgeInsets.all(10),
                   child: Container(
                       width: deviceSize.width * 0.43,
                       height: deviceSize.height * 0.1,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(color: Color.fromRGBO(44, 141, 121, 1))
                       ),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             setState(() {
                               firstChoice = "first";
                             });
                           });
                         },
                         child: Container(
                           width: deviceSize.width * 0.4,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child:  Center(
                             child: Column(
                               children: <Widget>[
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Container(
                                   padding: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     color: profile_info_background,
                                   ),
                                   child: Image.asset(
                                       "assets/password.png"
                                   ),
                                 ),
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Text(
                                   "Password",
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 15,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       )
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.all(10),
                   child: Container(
                       width: deviceSize.width * 0.43,
                       height: deviceSize.height * 0.1,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(color: Color.fromRGBO(44, 141, 121, 1))
                       ),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             setState(() {
                               firstChoice = "second";
                             });
                           });
                         },
                         child: Container(
                           width: deviceSize.width * 0.4,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: Center(
                             child: Column(
                               children: <Widget>[
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Container(
                                   padding: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     color: profile_info_background,
                                   ),
                                   child: Image.asset(
                                       "assets/pin.png"
                                   ),
                                 ),
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Text(
                                   "Pin",
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 15,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       )
                   ),
                 ),
               ],
             ),
             SizedBox(
               height: 20,
             ),
             Row(
               children: <Widget>[
                 Padding(
                   padding: EdgeInsets.all(10),
                   child: Container(
                       width: deviceSize.width * 0.43,
                       height: deviceSize.height * 0.1,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(color: Color.fromRGBO(44, 141, 121, 1))
                       ),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             setState(() {
                               firstChoice = "third";
                             });
                           });
                         },
                         child: Container(
                           width: deviceSize.width * 0.4,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child:  Center(
                             child: Column(
                               children: <Widget>[
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Container(
                                   padding: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     color: profile_info_background,
                                   ),
                                   child: Image.asset(
                                       "assets/card-setting.png"
                                   ),
                                 ),
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Text(
                                   "Card Setting",
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 15,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       )
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.all(10),
                   child: Container(
                       width: deviceSize.width * 0.43,
                       height: deviceSize.height * 0.1,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(color: Color.fromRGBO(44, 141, 121, 1))
                       ),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             setState(() {
                               firstChoice = "fourth";
                             });
                           });
                         },
                         child: Container(
                           width: deviceSize.width * 0.4,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: Center(
                             child: Column(
                               children: <Widget>[
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Container(
                                   padding: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     color: profile_info_background,
                                   ),
                                   child: Image.asset(
                                       "assets/setting.png"
                                   ),
                                 ),
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Text(
                                   "Wallet Banking",
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 15,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       )
                   ),
                 ),
               ],
             ),
           ],
         ),
        ):
        firstChoice == "first" ?
        Container(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _changePassFormKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            children: <Widget>[
                              TitleHead(
                                icon: 'true',
                                title: null,
                                logo: 'assets/logo_small.png',
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: _title("Change Password"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width:MediaQuery.of(context).size.width * 0.4,
                                child: Center(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        firstChoice = null;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.arrow_back),
                                        Text(
                                          "Tap To Change Method",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromRGBO(44, 149, 121, 1)
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              showOldPasswordInput(),
                              showPasswordInput(),
                              showConfirmPasswordInput(),
                              SizedBox(
                                height: 40,
                              ),
                              _submitButton(),
                            ],
                          ),
                        ),
                        _createAccountLabel()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ) : Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: <Widget>[
              TitleHead(
                icon: 'true',
                title: null,
                logo: 'assets/logo_small.png',
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: _title("Coming soon"),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width:MediaQuery.of(context).size.width * 0.4,
                child: Center(
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        firstChoice = null;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        Text(
                          "Tap To Change Method",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(44, 149, 121, 1)
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}