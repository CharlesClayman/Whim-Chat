import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whim_chat/src/core/screens/views/Chat_view.dart';
import 'package:whim_chat/src/core/screens/views/people_view.dart';
import 'package:whim_chat/src/core/screens/views/settings_view.dart';
import 'package:whim_chat/src/core/screens/views/stories_view.dart';

List<Widget> homeScreenItems = [
  ChatView(),
  PeopleView(),
  StoriesView(),
  SettingsView(),
];
