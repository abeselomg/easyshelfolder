// import 'package:easy_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// var authUrl = "https://99startups.xyz";
var authUrl = "https://easycoreet.com";
var payUrl = "https://easypayet.xyz";

Map<String, String> authHeaders = {
  'Accept': 'application/json',
  'Content-type': 'application/x-www-form-urlencoded',
};

class AuthAPI {
  Future sendVerificationCode(String phoneNumber) async {
    Map<String, dynamic> body = {"phoneNumber": phoneNumber};

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
    };

    try {
      return await http
          .post(Uri.encodeFull(authUrl + "/auth/send-verification-code"),
              headers: headers, body: json.encode(body))
          .then((http.Response response) async {
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

  Future<int> verifyCode(String code, String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> body = {
      "client_id": "phone_number_authentication",
      "client_secret": "secret",
      "grant_type": "PhoneNumber",
      "scope": "openid profile offline_access",
      "phone_number": phoneNumber,
      "verification_token": code
    };

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/x-www-form-urlencoded',
    };

    try {
      return await http
          .post(Uri.encodeFull(authUrl + "/connect/token"),
              headers: headers, body: body)
          .then((http.Response response) async {
        final int statusCode = response.statusCode;
        print(
            "*************************** verifyCode ${response.statusCode}***********************************");
        if (response.statusCode == 200) {
          print(response.body);
          var userdata = json.decode(response.body);
          prefs.setString('token', userdata['access_token']);
          // prefs.setString('acctoken', userdata['access_token']);

          prefs.setString('expires_in', userdata['expires_in'].toString());
          prefs.setString('refresh_token', userdata['refresh_token']);
          final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
          prefs.setString("currentTime", formatter.format(now));
          print("VerifyCode Success");
          return statusCode;
        }
        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error while fetching data");
        }
        return statusCode;
      });
    } catch (Exception, s) {
      print("Error AuthAPI verifyCode : ${Exception.toString()}");
      return 401;
    }
  }

  Future refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String refresh_token = prefs.getString("refresh_token");

    Map<String, dynamic> body = {
      "client_id": "phone_number_authentication",
      "client_secret": "secret",
      "grant_type": "refresh_token",
      "refresh_token": refresh_token
    };

    try {
      return await http
          .post(Uri.encodeFull(authUrl + "/connect/token"),
              headers: authHeaders, body: body)
          .then((http.Response response) async {
        final int statusCode = response.statusCode;
        print(
            "*************************** refreshToken ${response.statusCode}***********************************");
        if (response.statusCode == 200) {
          var userdata = json.decode(response.body);
          prefs.setString('token', userdata['access_token']);
          prefs.setString('expires_in', userdata['access_token']);
          prefs.setString('refresh_token', userdata['refresh_token']);
          final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
          prefs.setString("currentTime", formatter.format(now));
          // print("sssssssssssssssssssssssssssss ${formatter.format(now)}");
          print("Refresh Token Success");
          return statusCode;
        }
        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error while fetching data");
        }
        return statusCode;
      });
    } catch (Exception, s) {
      print("Error AuthAPI refreshToken : ${Exception.toString()}");
//      Crashlytics.instance
//          .recordError(Exception, s, context: 'Error on refreshToken api AuthAPI');
      return 401;
    }
  }

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    String noow = formatter.format(DateTime.now());
    final DateTime now = DateTime.parse(noow);

    DateTime savedTime = DateTime.parse(prefs.getString("currentTime"));
    Duration sub = now.difference(savedTime);
    if (sub.inHours > 0) {
      print("refresh token");
      await refreshToken();
    } else {
      print("token workes");
    }
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };

    try {
      http.Response response = await http
          .get(Uri.encodeFull(authUrl + "/connect/userinfo"), headers: headers);
      print(
          "************************************getUser statusCode ${response.statusCode}*********************************");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var userdata = json.decode(response.body);
        print(userdata);
        // _userMap = new User.map(userdata);
        prefs.setString("uid", userdata['id']).then((value) {
          print(value);
          print(prefs.getString('uid'));
          print(userdata['phoneNumber']);
        });
        prefs.setString('phone', userdata['phoneNumber']);
        prefs.setString('username', userdata['username']);

        return userdata;
      } else {
        print("User get from api returned null");
        return null;
      }
    } catch (Exception, s) {
      print("Error API getUser : ${Exception.toString()}");
      return null;
    }
  }

  Future getUserBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String uid = prefs.getString('uid');

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };

    try {
      http.Response response = await http.get(
          Uri.encodeFull(payUrl + "/api/v1/users/getbalance?sub=$uid"),
          headers: headers);
      print(
          "************************************getUser statusCode ${response.statusCode}*********************************");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var userdata = json.decode(response.body);
        print(userdata);
        // _userMap = new User.map(userdata);
        // prefs.setString("uid", userdata['id']).then((value) {
        //   print(value);
        //   print(prefs.getString('uid'));
        // });

        return userdata;
      } else {
        print("User get from api returned null");
        return null;
      }
    } catch (Exception, s) {
      print("Error API getUser : ${Exception.toString()}");
      return null;
    }
  }

  Future getBanks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String uid = prefs.getString('uid');

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };

    try {
      http.Response response = await http.get(
          Uri.encodeFull(payUrl + "/api/v1/users/get/deposit/banks?sub=$uid"),
          headers: headers);
      print(
          "************************************getBanks statusCode ${response.statusCode}*********************************");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var userdata = json.decode(response.body);
        print(userdata);
        // _userMap = new User.map(userdata);
        // prefs.setString("uid", userdata['id']).then((value) {
        //   print(value);
        //   print(prefs.getString('uid'));
        // });

        return userdata;
      } else {
        print("User get from api returned null");
        return null;
      }
    } catch (Exception, s) {
      print("Error API getUser : ${Exception.toString()}");
      return null;
    }
  }

  Future<int> putUser({Map body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': "Bearer $token",
    };

    try {
      return await http
          .put(Uri.encodeFull("https://99startups.xyz/api/users/profile"),
              headers: headers, body: json.encode(body))
          .then((http.Response response) async {
        final int statusCode = response.statusCode;
        print(
            "************************************ putUser statusCode ${response.statusCode} *********************************");
        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error while fetching data");
        }
        return statusCode;
      });
    } catch (Exception, s) {
      print("Error API putUser : ${Exception.toString()}");
      return 0;
    }
  }
}
