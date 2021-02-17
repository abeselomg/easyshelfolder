import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

// Define a custom Form widget.
class AddressPage extends StatefulWidget {
  @override
  Address createState() => Address();
}

class AddressList {
  String name;
  String desc;
  String loc;

  AddressList(this.name, this.desc,this.loc);

  AddressList.fromJson(Map<String, dynamic> json)
      : desc = json['desc'],
        name = json['name'],
        loc = json['loc'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'desc': desc,
    'loc': loc,
  };
}

class Address extends State<AddressPage>{
  List addressList = List();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController locController = TextEditingController();
  SharedPref sharedPref = new SharedPref();
  UserData user;

  @override
  void initState(){
    super.initState();
    initiateUser();
  }

  getItemAndNavigate(String type,String data){
    switch(type){
      case "add":
        user.address.add(AddressList(nameController.text, descController.text,locController.text));
        sharedPref.save("user", jsonEncode(user).toString());
        sharedPref.reload();
        break;
      case "update":
        user.address.asMap().forEach((key,element) {
          if(element["name"] == data){
            user.address[key]['name'] = nameController.text;
            user.address[key]['desc'] = descController.text;
            user.address[key]['loc'] = locController.text;
          }
        });
        sharedPref.save("user", user);
        break;
      default:
        print("default");
        break;
    }
    initiateUser();
    nameController.clear();
    descController.clear();
    locController.clear();
  }

  _showDialog(String type,String data) async {
    if(type == 'update')
      user.address.asMap().forEach((key,element) {
        if(element["name"] == data){
          nameController.text = user.address[key]['name'];
          descController.text = user.address[key]['desc'];
          locController.text = user.address[key]['loc'];
        }
      });
    await showDialog<String>(
      context: context,
      builder: (context) =>  new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListTile(title: Text("Add Address",style: TextStyle(color: Colors.blueAccent,fontSize: 16),),),
              ),
              Expanded(
                child: new TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      labelText: 'Address Name', hintText: 'eg. Home'),
                ),
              ),
              Expanded(
                child: new TextField(
                  controller: descController,
                  decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      labelText: 'Address Description', hintText: 'eg. Mesalemiya mobil , Jeberti Sefer Addis Ababa'),
                ),
              ),
              Expanded(
                child: new TextField(
                  controller: locController,
                  decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      labelText: 'Geolocation', hintText: 'eg. 9.036080,38.724429'),
                ),
              ),
              SizedBox(height: 10.0,),
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    _getLocation().then((value) {
                      descController.text = value['address'];
                      locController.text = value['loc'];
                    });
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Get Current Location', style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                nameController.clear();
                descController.clear();
                locController.clear();
                Navigator.pop(context);
              }),
          new FlatButton(
              child: type == "add" ? Text('Add'): Text('update'),
              onPressed: () {
                getItemAndNavigate(type,data);
                Navigator.pop(context);
              }
           )
        ],
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.playlist_add, color:Colors.black),
            onPressed: () => _showDialog("add",""),
          ),
        ],
        centerTitle: true,
        title: Text("Address",style: TextStyle(color: Colors.black),),
      ),
      body: user == null ? CircularProgressIndicator() :
      user.address == null ? Center(child: Text("No Address"),) :
      ListView.builder(
        itemCount: user.address.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        user.address[index]["name"],
                      ),
                      subtitle:Padding(child: Text(user.address[index]["desc"]),padding: EdgeInsets.only(top:5,bottom: 5),),
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: ColorizeAnimatedTextKit(
                        text: ["<< Swipe For more"],
                        textStyle: TextStyle(
                            fontSize: 10.0,
                        ),
                        colors: [
                          Colors.black,
                          Colors.white,
                          Colors.blueAccent,
                        ],
                        textAlign: TextAlign.start,
                        alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                    ),
                  )
                ],
              )
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Update',
                color: Colors.black45,
                icon: Icons.update,
                onTap: () => _showDialog("update",user.address[index]["name"]),
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  print('Delete');
                  deleteUserAddress(user.address[index]["name"]);
                  initiateUser();
                },
              ),
            ],
          );
        },
      ),
    );
  }
  Future<Map<String,dynamic>> _getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return {"address": "${first.featureName} : ${first.addressLine}","loc":"${position.latitude},${position.longitude}"};
  }
  void initiateUser() {
    sharedPref.read("user").then((value){
      print(value);
      var valueRead = jsonDecode(value);
      Map<String,String> walletRead = {
        "balance" : jsonDecode(value)["wallet"]["balance"],
        "lastUpdate" : jsonDecode(value)["wallet"]["lastUpdate"],
      };
      valueRead['wallet'] = walletRead;
      setState(() {
        user = UserData.fromJson(valueRead);
      });
    });
  }

  void deleteUserAddress(String data) {
    var toRemove = [];
    user.address.asMap().forEach((key,element) {
      if(element["name"] == data){
        toRemove.add(user.address[key]);
      }
    });
    user.address.removeWhere( (e) => toRemove.contains(e));
    sharedPref.save("user", user);
  }

}