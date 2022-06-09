import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:whim_chat/src/core/utils/colors.dart';
import 'home_view.dart';

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
  String formattedPhoneNum = "";

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  void NavigateToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void signUp() async {
    setState(() {
      _isLoading = true;
    });

    await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          NavigateToHome();
        },
        verificationFailed: (FirebaseAuthException ex) {},
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
            _codeSent = true;
            _verificationId = verificationId;
          });
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
        .then((value) => NavigateToHome());
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
                child: _codeSent ? otpVerification() : createAccount()))
      ]),
    );
  }

  //Layout for Phone number input
  Widget createAccount() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        //physics: const ClampingScrollPhysics(),

        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
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
                    formattedPhoneNum = number.toString();
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
                        ? const Text(
                            'Create Account',
                            style:
                                TextStyle(color: lightModeColor, fontSize: 18),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                  onTap: () {
                    signUp();
                  },
                ),
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
                  ?.merge(TextStyle(color: mainAppColor))),
        ),
        Text('Waiting to automatically detect OTP SMS to your number.',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.merge(TextStyle(color: Colors.white))),
        InkWell(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen())),
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            child: Text('Wrong number? Click here',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.merge(TextStyle(color: mainAppColor))),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03),
          child: OtpTextField(
            textStyle: TextStyle(color: Colors.white),
            numberOfFields: 6,
            cursorColor: mainAppColor,
            borderColor: mainAppColor,
            focusedBorderColor: mainAppColor,
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when every textfield is filled
            onSubmit: (String verificationCode) {
              print(verificationCode);
              verifyOtp(verificationCode);
            }, // end onSubmit
          ),
        ),
        Text('Enter 6-digits code',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.merge(TextStyle(color: Colors.white))),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.message,
                color: Colors.grey,
              ),
              Text('Resend OTP',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.merge(TextStyle(color: Colors.grey))),
              Text('54',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.merge(TextStyle(color: Colors.grey))),
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
