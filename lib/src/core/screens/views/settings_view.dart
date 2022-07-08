import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whim_chat/src/core/providers/theme_provider.dart';
import 'package:whim_chat/src/core/screens/widgets/profile_pic.dart';
import 'package:whim_chat/src/core/services/database_service.dart';
import 'package:whim_chat/src/core/utils/colors.dart';
import 'package:whim_chat/src/core/utils/themes.dart';
import '../../services/picker_service.dart';

class SettingsView extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _usernameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  Uint8List? _image;

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
    updateUserPic();
  }

  void onThemeChange(String value, ThemeProvider themeProvider) async {
    if (value == "Light") {
      themeProvider.setTheme(lightMode);
    } else if (value == "Dark") {
      themeProvider.setTheme(darkMode);
    }
    final pref = await SharedPreferences.getInstance();
    pref.setString("ThemeMode", value);
  }

  themeChangeDialog(ThemeProvider themeProvider) {
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Change Theme"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioGroup<String>.builder(
                        groupValue:
                            context.read<ThemeProvider>().getSelectedTheme,
                        onChanged: (value) {
                          context
                              .read<ThemeProvider>()
                              .setSelectedTheme(value!);

                          onThemeChange(
                              context.read<ThemeProvider>().getSelectedTheme,
                              themeProvider);
                        },
                        items: context.read<ThemeProvider>().getListOfThemes,
                        itemBuilder: (item) => RadioButtonBuilder(item))
                  ],
                ),
              );
            }));
  }

  updateUserPic() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_image != null) {
      String response = await DatabaseService().updateProfilePic(_image!);
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text(response == "success" ? "Update successful" : response)));
    }
  }

  updateUsername() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final String newUsername = _usernameController.text;
    if (newUsername.isNotEmpty) {
      String response = await DatabaseService().updateUsername(newUsername);
      navigator.pop();
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text(response == "success" ? "Updated successful" : response)));
    }
  }

  void showModalButtomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter name",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  TextField(
                    controller: _usernameController,
                    cursorColor: mainAppColor,
                    style: Theme.of(context).textTheme.subtitle1,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainAppColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainAppColor))),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: Container()),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.subtitle2,
                            )),
                        TextButton(
                            onPressed: updateUsername,
                            child: Text(
                              'Ok',
                              style: Theme.of(context).textTheme.subtitle2,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentUser = _auth.currentUser;
    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: mainAppColor),
            );
          }
          _usernameController.text = snapshot.data!['username'];
          return Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
                left: 20,
                right: 20),
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'Settings',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: mainAppColor),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
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
                        child: snapshot.data!.get("photoUrl") != null
                            ? CachedNetworkImage(
                                imageUrl: snapshot.data!.get("photoUrl"),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data!.get("photoUrl")),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.asset(
                                'assets/images/signupBackground.jpg',
                                fit: BoxFit.cover,
                              ),
                      ),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Flexible(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    'Username',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    snapshot.data!['username'],
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  trailing: IconButton(
                      onPressed: showModalButtomSheet,
                      icon: const Icon(Icons.mode)),
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: const Icon(Icons.wb_sunny),
                  title: Text(
                    'Theme',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    context.read<ThemeProvider>().getSelectedTheme,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        themeChangeDialog(themeProvider);
                      },
                      icon: const Icon(Icons.mode)),
                ),
              ),
              Flexible(
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(
                    'Phone',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    snapshot.data!['phone'],
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ]),
          );
        });
  }
}
