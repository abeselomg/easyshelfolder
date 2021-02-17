class PostData {
  String fname, lname , email,mobile ,country_code, password;

  PostData(this.fname, this.lname , this.email,this.mobile ,this.country_code, this.password);

  PostData.fromJson(Map<String, dynamic> json)
      : fname = json['first_name'],
        lname = json['last_name'],
        email = json['email'],
        mobile = json['phone'],
        country_code = json['phonecode'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {
        'first_name': fname,
        'last_name': lname,
        'email': email,
        'phone': mobile,
        'phonecode': country_code,
        'password': password,
      };
}