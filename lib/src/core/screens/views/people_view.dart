import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/models/user.dart' as model;
import 'package:whim_chat/src/core/providers/people_provider.dart';
import 'package:whim_chat/src/core/screens/views/conversation_view.dart';
import 'package:whim_chat/src/core/services/database_service.dart';
import 'package:whim_chat/src/core/utils/colors.dart';

class PeopleView extends StatefulWidget {
  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

//Dummy Data
  List<model.User> users() {
    List<model.User> list = [];
    list.add(const model.User(
        username: "Charles",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1584043720379-b56cd9199c94?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"));
    list.add(const model.User(
        username: "Mike",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1508341591423-4347099e1f19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"));
    list.add(const model.User(
        username: "Shantel",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1594409855476-29909f35c73c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80"));
    list.add(const model.User(
        username: "Nike",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1492288991661-058aa541ff43?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"));
    list.add(const model.User(
        username: "Jane",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1539701938214-0d9736e1c16b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=415&q=80"));
    list.add(const model.User(
        username: "Ann",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1590770357970-ec6480b368c0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"));
    list.add(const model.User(
        username: "Abigail",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1512413316925-fd4b93f31521?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"));
    list.add(const model.User(
        username: "James",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1559893088-c0787ebfc084?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"));
    list.add(const model.User(
        username: "Paulo",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1148&q=80"));
    list.add(const model.User(
        username: "Prissy",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"));
    list.add(const model.User(
        username: "Betty",
        phone: "+2342324325435",
        photoUrl:
            "https://images.unsplash.com/photo-1623762065223-e4d1e17cd3e6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=386&q=80"));
    return list;
  }

  addFriend(String id) async {
    context.read<PeopleProvider>().setAddingFriend(true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String response = await DatabaseService().addFriend(id);
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(response)));
  }

  @override
  Widget build(BuildContext context) {
    final userStream = firestore.collection('users').snapshots();
    late List friendsIds;
    return StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: ((context, snapshot) {
          snapshot.data?.docs
              .where((element) => element.id == auth.currentUser!.uid)
              .first
              .reference
              .collection('friends')
              .get()
              .then((value) {
            friendsIds = value.docs.map((e) => e.id).toList();
          });

          var newFriendsSnapshot = snapshot.data?.docs
              .where(((element) => element.id != auth.currentUser!.uid))
              .where((element) => !friendsIds.contains(element.id));

          return Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Friends',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.merge(const TextStyle(color: mainAppColor)),
                      ),
                    ),
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        removeLeft: true,
                        removeRight: true,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: users().length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConversationView(
                                          name: users()[index].username,
                                          photoUrl: users()[index].photoUrl,
                                        ),
                                      )),
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          backgroundImage: NetworkImage(
                                            users()[index].photoUrl,
                                          )),
                                      Positioned(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.006,
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.062,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green.shade400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  users()[index].username,
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.height * 0.025,
                            );
                          },
                        ),
                      ),
                    ),
                    Text(
                      'Discover new friends',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.merge(const TextStyle(color: mainAppColor)),
                    ),
                    Expanded(
                      flex: 3,
                      child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.separated(
                            itemCount: newFriendsSnapshot?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: MediaQuery.of(context).size.height *
                                        0.06,
                                    backgroundImage: NetworkImage(
                                      newFriendsSnapshot!
                                          .toList()[index]
                                          .get('photoUrl'),
                                    )),
                                title: Text(
                                  newFriendsSnapshot
                                      .toList()[index]
                                      .get('username'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.merge(const TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ),
                                trailing: IconButton(
                                    onPressed: () => addFriend(
                                        snapshot.data!.docs[index].id),
                                    icon: const Icon(Icons.add)),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                thickness: 0.2,
                                color: Colors.grey,
                              );
                            },
                          )),
                    )
                  ]));
        }));
  }
}
