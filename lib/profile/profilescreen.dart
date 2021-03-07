import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
// import 'dart:io';
import 'package:easy_shelf/helpers/TitleHead.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_categories.dart';
import 'profile_detail.dart';
import 'profile_menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'listOfBanks.dart';
import 'package:easy_shelf/views/Topup.dart';

class Profile extends StatefulWidget {
  final UserData user;
  final String balance;
  final String activeBalance;
  final String pendingBalance;

  Profile(
      {@required this.user,
      this.activeBalance,
      this.balance,
      this.pendingBalance});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    bool acba = false;
    bool pendba = false;
    bool bal = true;
    dynamic balanceText = 'Balance';
    File _image;
    final picker = ImagePicker();
    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("Success");
        print(_image);
        var base64Image = base64Encode(_image.readAsBytesSync());
        print(base64Image);
      } else {
        print('No image selected.');
      }

      await sendImage(pickedFile);
    }

    setter() {
      setState(() {
        balanceText = "result";
        acba = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1EB998)),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<dynamic>(
            onSelected: (dynamic result) {
              print(result);
              setter();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
              const PopupMenuItem<dynamic>(
                value: "Active Balance",
                child: Text('Active Balance'),
              ),
              const PopupMenuItem<dynamic>(
                value: "Pending Balance",
                child: Text('Pending Balance'),
              ),
              const PopupMenuItem<dynamic>(
                value: "c",
                child: Text('Logout'),
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    //  TitleHead(
                    //    title: null,
                    //    logo: 'assets/logo_small.png',
                    //    notification: "2",
                    //  ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    ProfileDetail(
                      user: widget.user,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    //  ProfileCategories(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // side: BorderSide(color: Colors.red)
                          ),
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),

                            padding: EdgeInsets.all(15),
                            height: MediaQuery.of(context).size.height * 0.3,
                            //  decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: TextStyle(
                                          fontFamily: 'AirbnbCerealBold',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_box_outlined,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Topup()));
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 70.0,
                                      height: 70.0,
                                      decoration: new BoxDecoration(
                                        color: Color(0xFF1EB998),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.account_balance_wallet,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      // balance != null ? balance.toStringAsFixed(2)+" Br" : '0.00'+" Br",
                                      "${widget.balance} Br",
                                      style: TextStyle(
                                          fontFamily: 'AirbnbCerealBold',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    SizedBox(
                                      width: 1,
                                    )
                                  ],
                                ),

                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(20),
                                //   child: RaisedButton(
                                //       child: Text(
                                //         "Deposit",
                                //         style: TextStyle(color: Colors.white),
                                //       ),
                                //       onPressed: () {},
                                //       color: Color(0xFF1EB998),
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(18.0),
                                //         // side: BorderSide(color: Colors.red)
                                //       )
                                //       // shape: ShapeBorder(),

                                //       ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    ProfileMenu(
                      widget.user,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future sendImage(PickedFile pickedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String uid = prefs.getString('uid');
    var stream =
        new http.ByteStream(DelegatingStream.typed(pickedFile.openRead()));
    // get file length
    var length = 1; //imageFile is your image file
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    }; // ignore this headers if there is no authentication

    // string to uri
    var uri = Uri.parse("easypayet.xyz/api/v1/users/deposit");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFileSign = new http.MultipartFile('screenshot', stream, length,
        filename: basename(pickedFile.path));

    // add file to multipart
    request.files.add(multipartFileSign);

    //add headers
    request.headers.addAll(headers);

    //adding params
    request.fields['amount'] = '12';
    request.fields['deposit_account'] = 'abc';
    request.fields['sub'] = uid;

    // send
    var response = await request.send();

    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
