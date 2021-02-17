class UserData {
  String  username,email,mobile ,country_code,contryname, password,profile;
  int id;
  List address = List();

  UserData(this.id,
          this.username,
          this.email,
          this.mobile,
          this.country_code,
          this.contryname,
          this.password,
          this.profile,
          this.address);

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        mobile = json['mobile'],
        country_code = json['country_code'],
        contryname = json['contryname'],
        profile = json['profile'],
        password = json['password'],
        address = json['address'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'username' : username,
        'email': email,
        'mobile': mobile,
        'country_code': country_code,
        'contryname': contryname,
        'profile' : profile,
        'password': password,
        'address': address,
      };
}