import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/profile/general.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EditProfilePage();
  }

}

class _EditProfilePage extends State<EditProfilePage> {
  File _image;
  String profileUrl;
  UserData user;
  SharedPref sharedPref = SharedPref();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController usernameInputController;
  String countryCode,contryName;
  bool _pressed = false;
  ProgressDialog progressDialog;
  @override
  void initState(){
    super.initState();
    _pressed = true;
    countryCode = "+251";
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    usernameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    initiateUser();
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  _updateCustomer(BuildContext context) async {
    String restStr = '/api/v1/users/profile/update/info';
    String url = urlSt+ restStr;
    var request = http.MultipartRequest("POST", Uri.parse(url));


    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey,
      "X-Requested-With": "XMLHttpRequest"
    };

    request.fields["fname"] = firstNameInputController.text;
    request.fields["lname"] = lastNameInputController.text;
    request.fields["mobile"] = countryCode+phoneInputController.text;
    request.fields["email"] = emailInputController.text;
    request.fields["username"] = usernameInputController.text;
    request.fields["user_id"] = user.id.toString();
    if(_image != null){
      var pic = await http.MultipartFile.fromPath("avatars", _image.path);
      request.files.add(pic);
    }
    request.headers.addAll(headers);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print("sending...");
        print(request.fields.toString());
        print(jsonDecode(value)['status']);
        print(jsonDecode(value));
        if(jsonDecode(value)['status'] == 200){
          var now = new DateTime.now();
          var formatter = new DateFormat.yMMMMd('en_US').add_jm();
          String formattedDate = formatter.format(now);
          UserData userData = UserData(
              user.id,
              usernameInputController.text,
              emailInputController.text,
              phoneInputController.text,
              countryCode,
              contryName,
              user.password,
              jsonDecode(value)['profile_url'],user.address);
          if(progressDialog.isShowing())
            progressDialog.hide().then((isHidden){
              sharedPref.save('user',jsonEncode(userData));
              sharedPref.reload();
              Alert(
                  context: context,
                  type: AlertType.success,
                  title: "Successful",
                  desc: jsonDecode(value)['success'],
                  buttons: [
                    DialogButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => GeneralPage()),
                        );
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();
            });
        }else{
          if(progressDialog.isShowing())
            progressDialog.hide().then((isHidden){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: ((context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("Please Try Again later"),
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

    }).catchError((e) {
      print(e);
      if(progressDialog.isShowing())
        progressDialog.hide().then((isHidden){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: ((context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("Please Try Again later"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text("OK")
                    )
                  ],
                );
              })
          );
        });
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() async {
      _image = image;
      print('Image Path $_image');
    });
  }

  Widget userNameInput() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new TextFormField(
        maxLines: 1,
        validator: usernameValidator,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'User Name',
            icon: new Icon(
              Icons.supervised_user_circle,
              color: Colors.grey,
            )),
        controller: usernameInputController,
//        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  String usernameValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'Username can\'t be empty';
    } else {
      return null;
    }
  }

  Widget showFNameInput() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
      padding: const EdgeInsets.all(15.0),
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

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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

  Widget showPhoneInput() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
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
                      contryName = c.code;
                    });
                  },
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  initialSelection: contryName,
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
            if (_editFormKey.currentState.validate()) {
              progressDialog.show();
              _updateCustomer(context);
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
              'Edit',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("Edit Profile",style: TextStyle(color: Colors.black),),
      ),
      body: user == null ? Container():
     Form(
       key: _editFormKey,
       child:  ListView(
         children: <Widget>[
           Container(
             height: 140,
             decoration: BoxDecoration(
                 gradient: LinearGradient(
                     begin: Alignment.centerLeft,
                     end: Alignment.centerRight,
                     stops: [0.3,0.6, 0.9],
                     colors: [
                       Color.fromRGBO(44, 149, 121, 1.0),
                       Color.fromRGBO(44, 139, 111, 1.0),
                       Color.fromRGBO(30, 129, 101, 0.5),
                     ]
                 )
             ),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Align(
                       alignment: Alignment.center,
                       child: CircleAvatar(
                         radius: 40,
                         backgroundColor: Colors.white,
                         child: ClipOval(
                           child: new SizedBox(
                             width: 80.0,
                             height: 80.0,
                             child: (_image!=null)?Image.file(
                               _image,
                               fit: BoxFit.fill,
                             ):Image.network(
                               profileUrl == null ? "https://app.hellotegena.com/assets/images/user.png"
                                   : profileUrl ,
                               fit: BoxFit.fill,
                             ),
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 60.0),
                       child: IconButton(
                         icon: Icon(
                           Icons.camera,
                           size: 30.0,
                         ),
                         onPressed: () {
                           _showPicker(context);
                         },
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
           showFNameInput(),
           Divider(),
           showLNameInput(),
           Divider(),
           userNameInput(),
           Divider(),
           showEmailInput(),
           Divider(),
           showPhoneInput(),
           Divider(),
           _submitButton()
         ],
       ),
     ),
    );
  }

  void initiateUser() {
    sharedPref.read("user").then((value) {
      // print(value);
      var valueRead = jsonDecode(value);
      Map<String,String> walletRead = {
        "balance" : jsonDecode(value)["wallet"]["balance"],
        "lastUpdate" : jsonDecode(value)["wallet"]["lastUpdate"],
      };
      valueRead['wallet'] = walletRead;
      setState(() {
        if(value != null)
          user = UserData.fromJson(valueRead);
          profileUrl = user.profile ?? null;
          contryName = user.contryname ?? "ET";
          firstNameInputController.text = user.username ?? "";
          phoneInputController.text = user.mobile ?? "";
          usernameInputController.text = user.username ?? "";
          emailInputController.text = user.email ?? "";
      });
    });
  }
}