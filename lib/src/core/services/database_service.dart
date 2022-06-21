import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whim_chat/src/core/models/user.dart' as model;
import 'package:whim_chat/src/core/services/storage_service.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> setUpProfile({
    required String username,
    required String phone,
    required Uint8List profileImage,
  }) async {
    String response = "Something went wrong";
    try {
      if (username.isNotEmpty || profileImage != null) {
        //Uploading profile picture and getting url of the image path
        String photoUrl = await StorageService()
            .uploadImageToStorage('profilePics', profileImage);

        model.User _user =
            model.User(username: username, phone: phone, photoUrl: photoUrl);
        //adding user info to database
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set(_user.toJson());

        response = "success";
      } else {
        response = "there exist and empty field";
      }
    } catch (ex) {
      response = ex.toString();
    }

    return response;
  }

  Future<String> updateUsername(String username) async {
    String response = "Something Went wrong";
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'username': username}).then((_) => response = "success");
    } catch (ex) {
      response = ex.toString();
    }

    return response;
  }

  Future<String> updateProfilePic(Uint8List image) async {
    String response = "Something went wrong";
    try {
      String photoUrl =
          await StorageService().uploadImageToStorage("profilePics", image);
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({"photoUrl": photoUrl}).then((_) => response = "success");
    } catch (ex) {
      response = ex.toString();
    }
    return response;
  }

  Future<String> addFriend(String friendId) async {
    String response = "Something went wrong";
    try {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('friends')
          .doc(friendId)
          .set({});

      response = "Success";
    } catch (ex) {
      response = ex.toString();
    }
    return response;
  }
}
