import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResetPass extends StatefulWidget {
  ResetPass({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass>{

  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController phoneInputController;
  TextEditingController passInputController;
  TextEditingController codeInputController;
  var _pressed;
  ProgressDialog progressDialog;

  @override
  initState() {
    phoneInputController = new TextEditingController();
    codeInputController = new TextEditingController();
    _pressed = false;
    super.initState();
  }

  Widget showPhoneInput() {

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        maxLength: 9,
        decoration: new InputDecoration(
            hintText: 'Phone',
            prefixText: '+251',
            icon: new Icon(
              Icons.call,
              color: Colors.grey,
            )),
        controller: phoneInputController,
        validator: phoneValidator,
//        onSaved: (value) => _phone = value.trim(),
      ),
    );
  }

  String phoneValidator(String value) {
    if (value.isEmpty || value.length == 0) {
      return 'Phone can\'t be empty';
    } else if (value.length < 9){
      return 'Invalid phone entered';
    }else{
      return null;
    }
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Reset Password',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color.fromRGBO(44, 149, 121, 1.0),
        ),),
    );
  }

  Future<bool> reset(String phone, BuildContext context) async {
    if(progressDialog.isShowing())
      progressDialog.hide();
    return true;
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
            if (_resetFormKey.currentState.validate()) {
              final phone = "+251"+phoneInputController.text.trim();
              progressDialog.show();
              // do staff
              reset(phone, context);
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
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.lightGreen, Color.fromRGBO(44, 149, 121, 1.0)])),
            child: Text(
              'Next',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      );


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        //          backgroundColor: Color(0xff3a3637),
        backgroundColor: Color(0xff33A48C),
        title: Text(
          "Reset Password",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _resetFormKey,
            autovalidate: _autoValidate,
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        _title(),
                        SizedBox(
                          height: 40,
                        ),
                        showPhoneInput(),
                        SizedBox(
                          height: 60,
                        ),
                        _submitButton(),
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}