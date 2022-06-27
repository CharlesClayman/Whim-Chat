import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/models/user.dart' as model;
import 'package:whim_chat/src/core/providers/people_provider.dart';
import 'package:whim_chat/src/core/screens/views/conversation_view.dart';
import 'package:whim_chat/src/core/services/database_service.dart';
import 'package:whim_chat/src/core/utils/colors.dart';
import 'package:tuple_dart/tuple_dart.dart';

class PeopleView extends StatefulWidget {
  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late List friendsIds;
  late var friendsSnapshot;
  late var discoverFriendsSnapshot;

  addFriend(String id) async {
    context.read<PeopleProvider>().setAddingFriend(true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String response = await DatabaseService().addFriend(id);
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(response)));
  }

  Stream<Iterable<String>> friendsIDsStream(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) async* {
    var friends = snapshot.data?.docs
        .where((element) => element.id == auth.currentUser!.uid)
        .first
        .reference
        .collection('friends')
        .get();

    Stream<Iterable<String>> friendIdsStream =
        friends!.asStream().map((event) => event.docs.map((e) => e.id));
    yield* friendIdsStream;
  }

  Iterable<QueryDocumentSnapshot<Object?>> getSnapshotOfFriends(
      dynamic snapshot) {
    return snapshot.data!.docs
        .where((element) => friendsIds.contains(element.id));
  }

  Iterable<QueryDocumentSnapshot<Object?>> getSnapshotOfDiscovFrnds(
      dynamic snapshot) {
    return snapshot.data?.docs
        .where(((element) => element.id != auth.currentUser!.uid))
        .where((element) => !friendsIds.contains(element.id));
  }

  navigateToConvoScreen(dynamic friendsSnapshot, int index) {
    context.read<PeopleProvider>().setChatProfile(
        friendsSnapshot!.toList()[index].get('username'),
        friendsSnapshot.toList()[index].get('photoUrl'));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationView(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: firestore.collection('users').get(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            var friendIdsStream = friendsIDsStream(snapshot);

            return StreamBuilder(
                stream: friendIdsStream,
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    friendsIds = (snapshot2.data as Iterable).toList();
                    friendsSnapshot = getSnapshotOfFriends(snapshot);
                    discoverFriendsSnapshot =
                        getSnapshotOfDiscovFrnds(snapshot);

                    return Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  'Friends',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.merge(
                                          const TextStyle(color: mainAppColor)),
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
                                    itemCount:
                                        friendsSnapshot?.toList().length ?? 0,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () => navigateToConvoScreen(
                                                friendsSnapshot, index),
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    radius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      friendsSnapshot!
                                                          .toList()[index]
                                                          .get('photoUrl'),
                                                    )),
                                                Positioned(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.006,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.062,
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Colors.green.shade400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            friendsSnapshot
                                                .toList()[index]
                                                .get('username'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.025,
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
                                    ?.merge(
                                        const TextStyle(color: mainAppColor)),
                              ),
                              Expanded(
                                flex: 3,
                                child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    removeBottom: true,
                                    child: ListView.separated(
                                      itemCount:
                                          discoverFriendsSnapshot?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              backgroundImage: NetworkImage(
                                                discoverFriendsSnapshot!
                                                    .toList()[index]
                                                    .get('photoUrl'),
                                              )),
                                          title: Text(
                                            discoverFriendsSnapshot
                                                .toList()[index]
                                                .get('username'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.merge(const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                          trailing: IconButton(
                                              onPressed: () => addFriend(
                                                  snapshot
                                                      .data!.docs[index].id),
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
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
