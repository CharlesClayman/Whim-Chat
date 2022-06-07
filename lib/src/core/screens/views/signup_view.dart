import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:whim_chat/src/core/utils/colors.dart';

import 'home_view.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool otpVisibility = false;
  String verificationID = "";
  String phone = "";

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/signupBackground.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
            child: Container(
          color: Colors.black.withOpacity(0.8),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            children: [
              Expanded(child: Container()),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              //Welcome text
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Welcome to Whim Chat',
                  style: TextStyle(color: mainAppColor, fontSize: 35),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              //App logo
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: CircleAvatar(
                  radius: 85,
                  backgroundImage: AssetImage('assets/images/Whim_Logo.jpg'),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              //Phone textField
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  phone = number.toString();
                },
                onInputValidated: (bool value) {
                  //  print(value);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(color: Colors.white),
                textFieldController: _phoneController,
                cursorColor: mainAppColor,
                spaceBetweenSelectorAndTextField: 0,
                inputDecoration: const InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(color: mainAppColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainAppColor),
                    ),
                    border: UnderlineInputBorder(),
                    focusColor: mainAppColor),
                textStyle: const TextStyle(color: Colors.white),
                formatInput: false,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: const OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  //print('On Saved: $number');
                },
              ),
              //OTP textfield
              Row(children: [
                Icon(
                  Icons.pin_outlined,
                  color: mainAppColor,
                  size: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.12,
                ),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: _otpController,
                      decoration: const InputDecoration(
                          labelText: "OTP",
                          labelStyle: TextStyle(color: mainAppColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainAppColor),
                          ),
                          border: UnderlineInputBorder(),
                          focusColor: mainAppColor),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              InkWell(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    color: mainAppColor,
                  ),
                  child: !_isLoading
                      ? Text(
                          otpVisibility ? "Verify" : "Login",
                          style: const TextStyle(
                              color: brightModeColor, fontSize: 18),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
                onTap: () {
                  if (otpVisibility) {
                    // verifyOTP();
                  } else {
                    login();
                  }
                },
              ),
              Expanded(child: Container()),
            ],
          ),
        ))
      ]),
    );
  }

  void login() async {
    _phoneController.text = phone;
    setState(() {
      _isLoading = true;
    });
    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException ex) {},
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
          });
          otpVisibility = true;
          verificationID = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  void verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: _otpController.text);

    await _auth.signInWithCredential(credential).then((value) =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }
}
