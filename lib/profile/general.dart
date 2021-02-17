import 'dart:convert';
import 'dart:io';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/main.dart';
import 'package:easy_shelf/views/EditProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GeneralPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return General();
  }

}

class General extends State<GeneralPage> {
  File _image;
  String profileUrl;
  UserData user;
  SharedPref sharedPref = SharedPref();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  MaskTextInputFormatter phoneMask = new MaskTextInputFormatter(mask: "+(251) 9## ######",filter: {"#": RegExp(r'[0-9]')});
  @override
  void initState(){
    super.initState();
    initiateUser();
  }

  Future<Map<String,dynamic>> _updateCustomer() async {
    final http.Response response = await http.post(
      'https://app.hellotegena.com/api/updatecustomers',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept' : 'application/json'
      },
      body: jsonEncode(<String,dynamic> {
        'id' : user.id,
        'name' : nameController.text,
      }),
    );
    var responseJson = jsonDecode(response.body);
    return responseJson ?? {};
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() async {
      _image = image;
      // await uploadPic();
      print('Image Path $_image');
    });
  }
  // Future uploadPic() async{
  //   String fileName = basename(_image.path);
  //   StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
  //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
  //   StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
  //   var imageUrl = await taskSnapshot.ref.getDownloadURL() ;
  //   user.profile = imageUrl;
  //   sharedPref.save("user", user);
  //   updateFirebaseAuth();
  //   initiateUser();
  //   setState(() {
  //     print("Profile Picture uploaded");
  //   });
  // }
  Future updateFirebaseAuth() async{
    // FirebaseUser f_user = await FirebaseAuth.instance.currentUser();
    //
    // UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    // userUpdateInfo.displayName = user.name;
    // userUpdateInfo.photoUrl = user.profile;
    //
    // f_user.updateProfile(userUpdateInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyAppPage(page: 4,))),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color:Colors.black),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditProfilePage()),
            ),
          ),
        ],
        centerTitle: true,
        title: Text("General Settings",style: TextStyle(color: Colors.black),),
      ),
      body: user == null ? Container():
      ListView(
        children: <Widget>[
          Container(
            height: 200,
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
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 100.0,
                        height: 100.0,
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
                SizedBox(height: 10,),
                Text(user.username  != null ? user.username : "", style: TextStyle(fontSize: 22.0, color: Colors.white),),
              ],
            ),
          ),
          ListTile(
            title: Text("UserName", style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),),
            subtitle: Text(user.username ?? "", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Email", style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),),
            subtitle: Text(user.email ?? "", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Phone", style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),),
            subtitle: Text(user.mobile != null ? (user.country_code??'')+ user.mobile : "undefined",
              style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
        ],
      ),
    );
  }

  void initiateUser() {
    sharedPref.read("user").then((value) {
      var valueRead = jsonDecode(value);
      Map<String,String> walletRead = {
        "balance" : jsonDecode(value)["wallet"]["balance"],
        "lastUpdate" : jsonDecode(value)["wallet"]["lastUpdate"],
      };
      valueRead['wallet'] = walletRead;
      print(valueRead);
      setState(() {
        if(value != null)
          user = UserData.fromJson(valueRead);
        profileUrl = user.profile;
      });
    });
  }
}