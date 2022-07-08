import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/models/chat_messege.dart';
import 'package:whim_chat/src/core/providers/people_provider.dart';
import 'package:whim_chat/src/core/screens/widgets/message_decor.dart';
import 'package:whim_chat/src/core/screens/widgets/profile_pic.dart';
import 'package:whim_chat/src/core/services/database_service.dart';

class ConversationView extends StatefulWidget {
  const ConversationView();
  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late var currentUser;

  sendMessage(String recipientId) async {
    String message = _messageController.text;
    _messageController.clear();
    if (message.isNotEmpty) {
      await DatabaseService().sendMessage(ChatMessage(
          from: _auth.currentUser!.uid,
          to: recipientId,
          body: message,
          timeStamp: DateTime.now()));
    }
  }

  //Retrieves messages related specific participants from private messages collection
  List<QueryDocumentSnapshot> getChatSpecificToUsers(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    currentUser = _auth.currentUser!.uid;
    return snapshot.data!.docs
        .where((document) =>
            (document.get('from') == context.read<PeopleProvider>().friendId &&
                document.get('to') == currentUser) ||
            (document.get('from') == currentUser &&
                document.get('to') == context.read<PeopleProvider>().friendId))
        .toList();
  }

  //Sorts the given chat messsages according to time sent
  sortMessages(List<QueryDocumentSnapshot> data) {
    data.sort((a, b) => a.get('timeStamp').compareTo(b.get('timeStamp')));
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatStream =
        FirebaseFirestore.instance.collection('privateMessages').snapshots();
    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(context.read<PeopleProvider>().friendId)
        .snapshots();

    currentUser = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
          title: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            context.read<PeopleProvider>().setChatProfile(snapshot.data);
          }
          return Row(
            children: [
              context.read<PeopleProvider>().friendPhotoUrl != null
                  ? ProfilePic(
                      width: MediaQuery.of(context).size.height * 0.05,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Image.network(
                        context.read<PeopleProvider>().friendPhotoUrl!,
                        fit: BoxFit.cover,
                      ))
                  : ProfilePic(
                      width: MediaQuery.of(context).size.height * 0.05,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Image.asset(
                        'assets/images/signupBackground.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                children: [
                  Text(context.read<PeopleProvider>().friendUsername,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.merge(const TextStyle(color: Colors.white))),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.004,
                  ),
                  Text(
                    context.read<PeopleProvider>().status,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.merge(const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ],
          );
        },
      )),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                var data = getChatSpecificToUsers(snapshot);

                return SingleChildScrollView(
                  reverse: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: ((context, index) {
                        sortMessages(data);
                        //Render messages on left or right depending on who sent or who is recieving what
                        if (data[index].get('from') == currentUser) {
                          return MessageDecorator(
                            alignment: Alignment.topRight,
                            margRight: 5,
                            margLeft: 70,
                            child: Text(data[index].get('body')),
                          );
                        }
                        return MessageDecorator(
                          alignment: Alignment.topLeft,
                          margRight: 70,
                          margLeft: 5,
                          child: Text(data[index].get('body')),
                        );
                      })),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: ShapeDecoration(
                color: Colors.grey.shade300,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: TextField(
                    controller: _messageController,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  )),
                  IconButton(
                      onPressed: () =>
                          sendMessage(context.read<PeopleProvider>().friendId),
                      icon: const Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
