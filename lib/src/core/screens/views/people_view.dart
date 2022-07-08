import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whim_chat/src/core/screens/widgets/discover.dart';
import 'package:whim_chat/src/core/screens/widgets/friend.dart';
import 'package:whim_chat/src/core/utils/colors.dart';

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

  //Generates a stream of friends Ids from current user's friends collection
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

  //Returns snapsnot of friends by using the ids from friendsIDsStream to fetch info from users collection
  Iterable<QueryDocumentSnapshot<Object?>> getSnapshotOfFriends(
      dynamic snapshot) {
    return snapshot.data!.docs
        .where((element) => friendsIds.contains(element.id));
  }

  //Returns snapsnot of non-friends by using the ids from friendsIDsStream to filter from users collection
  //to get non-friends and then fetch info from the collection(users)
  Iterable<QueryDocumentSnapshot<Object?>> getSnapshotOfDiscovFrnds(
      dynamic snapshot) {
    return snapshot.data?.docs
        .where(((element) => element.id != auth.currentUser!.uid))
        .where((element) => !friendsIds.contains(element.id));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').snapshots(),
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
                                      return Friend(
                                        friendsSnapshot: friendsSnapshot,
                                        index: index,
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
                                        return DiscoverFriend(
                                            discoverFriendsSnapshot:
                                                discoverFriendsSnapshot,
                                            index: index);
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
