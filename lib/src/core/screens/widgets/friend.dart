import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/screens/widgets/profile_pic.dart';
import 'package:flutter/material.dart';

import '../../providers/people_provider.dart';
import '../views/conversation_view.dart';

/// Creates a widget that has the user profile picture with username below it and status indicator
/// Navigates to friend's chat on click
///
class Friend extends StatelessWidget {
  //Snapshot of friends from firestore
  final dynamic friendsSnapshot;
  //Index of the specific friend on the friends list
  final int index;

  const Friend({
    required this.friendsSnapshot,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    goToConversation(dynamic friendsSnapshot, int index) {
      context
          .read<PeopleProvider>()
          .setChatProfile(friendsSnapshot!.toList()[index]);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConversationView(),
          ));
    }

    return Column(
      key: Key(friendsSnapshot.toList()[index].get('id')),
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => goToConversation(friendsSnapshot, index),
          child: Stack(
            children: [
              friendsSnapshot!.toList()[index].get('photoUrl') != null
                  ? ProfilePic(
                      width: MediaQuery.of(context).size.height * 0.065,
                      height: MediaQuery.of(context).size.height * 0.065,
                      child: Image.network(
                        friendsSnapshot!.toList()[index].get('photoUrl'),
                        fit: BoxFit.cover,
                      ))
                  : ProfilePic(
                      width: MediaQuery.of(context).size.height * 0.07,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Image.asset(
                        'assets/images/signupBackground.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
              Visibility(
                visible:
                    friendsSnapshot!.toList()[index].get('status') != 'Offline'
                        ? true
                        : false,
                child: Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.004,
                    left: MediaQuery.of(context).size.height * 0.05,
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.02,
                      height: MediaQuery.of(context).size.height * 0.02,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(173, 255, 47, 1)),
                    )),
              ),
            ],
          ),
        ),
        Text(
          friendsSnapshot.toList()[index].get('username'),
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
