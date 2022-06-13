import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:whim_chat/src/core/screens/views/signup_profile_view.dart';
import 'package:whim_chat/src/core/screens/widgets/custom_button.dart';
import 'package:whim_chat/src/core/utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _codeSent = false;
  String _verificationId = "";
  String _formattedPhoneNum = "";
  int _resendOtpCountdown = 60;
  late Timer _timer;
  bool _isTimeOut = false;

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendOtpCountdown == 0
          ? setState(() {
              _isTimeOut = true;
              _timer.cancel();
            })
          : setState(() => --_resendOtpCountdown);
    });
  }

  void navigateToSetupProfile() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SetUpProfile(
                  phoneNumber: _formattedPhoneNum,
                )));
  }

  void signUp() async {
    setState(() {
      _isLoading = true;
    });

    await _auth.verifyPhoneNumber(
        phoneNumber: _formattedPhoneNum,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          navigateToSetupProfile();
        },
        verificationFailed: (FirebaseAuthException ex) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(ex.toString())));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
            _codeSent = true;
          });
          _verificationId = verificationId;
          startTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  void verifyOtp(String otpCode) async {
    setState(() {
      _isLoading = true;
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otpCode);
    await _auth
        .signInWithCredential(credential)
        .then((value) => navigateToSetupProfile());
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
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: _codeSent ? otpVerification() : createAccount(),
        ))
      ]),
    );
  }

  //Layout for Phone number input
  Widget createAccount() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Expanded(child: Container()),
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
                    _formattedPhoneNum = number.toString();
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
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                CustomerButton(
                    onTapFunction: () => signUp(),
                    isLoading: _isLoading,
                    label: "Create Account"),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      );
    });
  }

  //Layout for OTP verification
  Widget otpVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: AppBar().preferredSize.height,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.04),
          child: Text('Verify Phone',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.merge(const TextStyle(color: mainAppColor))),
        ),
        Text('Waiting to automatically detect OTP SMS to your number.',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.merge(const TextStyle(color: Colors.white))),
        InkWell(
          onTap: () => setState(() => _codeSent = false),
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            child: Text('Wrong number? Click here',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.merge(const TextStyle(color: mainAppColor))),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03),
          child: OtpTextField(
            textStyle: const TextStyle(color: Colors.white),
            numberOfFields: 6,
            cursorColor: mainAppColor,
            borderColor: mainAppColor,
            focusedBorderColor: mainAppColor,
            showFieldAsBox: true,
            onSubmit: (String verificationCode) {
              verifyOtp(verificationCode);
            },
          ),
        ),
        Text('Enter 6-digits code',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.merge(const TextStyle(color: Colors.white))),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(
                Icons.message,
                color: Colors.grey,
              ),
              Visibility(
                visible: _isTimeOut,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(mainAppColor)),
                    onPressed: () {
                      setState(() {
                        _resendOtpCountdown = 60;
                        _isTimeOut = false;
                      });
                      signUp();
                    },
                    child: Text('Resend OTP',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.merge(const TextStyle(color: Colors.white)))),
              ),
              Visibility(
                visible: !_isTimeOut,
                child: Text(_resendOtpCountdown.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.merge(const TextStyle(color: Colors.grey))),
              ),
            ],
          ),
        ),
        Visibility(
            visible: _isLoading,
            child: const CircularProgressIndicator(
              color: mainAppColor,
            ))
      ],
    );
  }
}
