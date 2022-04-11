import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/textForm.dart';
import 'package:bonfire_newbonfire/service/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ResetPassPage extends StatefulWidget {
  const ResetPassPage({Key key}) : super(key: key);

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  AuthProvider _auth;
  String _resetEmail;
  GlobalKey<FormState> _resetKey;

  _ResetPassPageState() {
    _resetKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Reset password"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade200, size: 22.0,),
        ),
      ),
      body: Form(
        key: _resetKey,
        onChanged: () =>
            _resetKey.currentState.save(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "Enter your email",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade200),
              ),
              TextFormField(
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.grey.shade200, fontSize: 20.0),
                textAlign: TextAlign.left,
                validator: (_input) {
                  return _input.length != 0 && _input.contains("@")
                      ? null
                      : "Please enter a valid email";
                },
                onSaved: (_input) {
                  setState(() {
                    _resetEmail = _input;
                  });
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: resetButton()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resetButton() {
    return     _auth.status == AuthStatus.Authenticating
        ? Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).indicatorColor,
      ),
    )
        : OurFilledButton(
        context: context,
        text: "Reset password",
        onPressed: () async {
          if (_resetKey.currentState.validate()) {
            _auth.changePassword(_resetEmail, context);
            _auth.status == AuthStatus.Authenticated;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.all(new Radius.circular(12)),
                ),
                duration: const Duration(seconds: 5), // default 4s
                content: const Text('Check your email and reset your password', style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
            Navigator.pop(context);
          }
        },
    );
  }
}
