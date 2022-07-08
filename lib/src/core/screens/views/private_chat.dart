import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../providers/chatlist_provider.dart';
import '../../providers/people_provider.dart';
import '../../services/database_service.dart';
import '../widgets/profile_pic.dart';
import 'conversation_view.dart';

class PrivateChat extends StatefulWidget {
  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final currentUser = FirebaseAuth.instance.currentUser!.uid;

//sets the lastMessage and lastMessageTime( time sent ) property of any given friend on the list of chats
  getLateMessageNTime(AsyncSnapshot<QuerySnapshot> snapshot,
      List<dynamic> chatlist, int index) {
    var messagesList = snapshot.data!.docs
        .where((document) =>
            (document.get('from') == chatlist[index] &&
                document.get('to') == currentUser) ||
            (document.get('from') == currentUser &&
                document.get('to') == chatlist[index]))
        .toList();
    messagesList
        .sort((a, b) => a.get('timeStamp').compareTo(b.get('timeStamp')));

    var lastMessage = messagesList.last.get('body');

    var lastMessageTime = DateFormat.jm()
        .format(messagesList.last.get('timeStamp').toDate())
        .toString();

    context
        .read<ChatlistProvider>()
        .setLastMessageNTime(lastMessage, lastMessageTime);
  }

  goToChat(AsyncSnapshot<DocumentSnapshot> snapshot) {
    context.read<PeopleProvider>().setChatProfile(snapshot.data);
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const ConversationView())));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        //This stream builder retrieves  chat list of current user from chatlist collection
        child: Builder(
      builder: (context) => StreamBuilder(
        stream: DatabaseService().getChatlistStream(),
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
            var chatlist = (snapshot.data as Iterable).toList();
            return Expanded(
                child: ListView.separated(
              itemCount: chatlist.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  //This future builder retreives personal info(from users collection) of each person on the chatlist
                  //using the ids from the stream builder above it
                  child: FutureBuilder<DocumentSnapshot>(
                      future: _firestore
                          .collection('users')
                          .doc(chatlist[index])
                          .get(),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasError) {
                          return const Text('');
                        }

                        if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('');
                        }
                        if (snapshot2.hasData) {
                          return InkWell(
                            //This stream builder helps keep track of the last message sent and the time sent
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('privateMessages')
                                    .snapshots(),
                                builder: ((context, snapshot3) {
                                  if (snapshot3.hasData) {
                                    getLateMessageNTime(
                                        snapshot3, chatlist, index);
                                  }

                                  return ListTile(
                                    onTap: () => goToChat(snapshot2),
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: snapshot2.data!.get('photoUrl') !=
                                            null
                                        ? ProfilePic(
                                            padleft: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: Image.network(
                                              snapshot2.data!.get('photoUrl'),
                                              fit: BoxFit.cover,
                                            ))
                                        : ProfilePic(
                                            padleft: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: Image.asset(
                                              'assets/images/signupBackground.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    title: Text(
                                      snapshot2.data!.get('username'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.merge(const TextStyle(
                                              fontWeight: FontWeight.normal)),
                                    ),
                                    subtitle: Text(
                                      context
                                          .read<ChatlistProvider>()
                                          .lastMessage,
                                    ),
                                    trailing: Text(context
                                        .read<ChatlistProvider>()
                                        .lastMessageTime),
                                  );
                                })),
                          );
                        }

                        return const Text('');
                      }),
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: const Divider(
                    thickness: 0.2,
                    color: Colors.grey,
                  ),
                );
              },
            ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ));
  }
}
