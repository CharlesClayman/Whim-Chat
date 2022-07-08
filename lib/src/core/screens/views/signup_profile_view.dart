import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whim_chat/src/core/screens/views/home_view.dart';
import 'package:whim_chat/src/core/screens/widgets/custom_button.dart';
import 'package:whim_chat/src/core/screens/widgets/profile_pic.dart';
import 'package:whim_chat/src/core/services/database_service.dart';
import 'package:whim_chat/src/core/services/picker_service.dart';
import 'package:whim_chat/src/core/utils/colors.dart';

class SetUpProfile extends StatefulWidget {
  final String? phoneNumber;
  const SetUpProfile({required this.phoneNumber});

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  void getImage() async {
    Uint8List image = await imagePicker(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void setUpUser() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState((() => _isLoading = true));
    String response = await DatabaseService().setUpProfile(
        username: _usernameController.text,
        phone: widget.phoneNumber!,
        profileImage: _image);
    if (response == "success") {
      setState(() => _isLoading = false);
      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      setState(() => _isLoading = false);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(response)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 25,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.08),
            child: Text(
              'Profile Information',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: mainAppColor),
            ),
          ),
          Stack(children: [
            _image != null
                ? ProfilePic(
                    width: MediaQuery.of(context).size.height * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Image.memory(
                      _image!,
                      fit: BoxFit.cover,
                    ))
                : ProfilePic(
                    width: MediaQuery.of(context).size.height * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Image.asset(
                      'assets/images/signupBackground.jpg',
                      fit: BoxFit.cover,
                    )),
            Positioned(
                bottom: -(MediaQuery.of(context).size.height * 0.01),
                left: MediaQuery.of(context).size.height * 0.11,
                child: IconButton(
                  iconSize: MediaQuery.of(context).size.height * 0.05,
                  onPressed: getImage,
                  icon: const Icon(
                    Icons.add_a_photo,
                  ),
                )),
          ]),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05),
            child: TextField(
              controller: _usernameController,
              cursorColor: mainAppColor,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                prefixStyle: TextStyle(color: mainAppColor),
                hintText: 'Username',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainAppColor)),
              ),
            ),
          ),
          CustomerButton(
            onTapFunction: setUpUser,
            isLoading: _isLoading,
            label: "finish",
          ),
          Expanded(child: Container()),
        ],
      ),
    ));
  }
}
