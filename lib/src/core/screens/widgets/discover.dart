import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/screens/widgets/profile_pic.dart';
import '../../providers/people_provider.dart';
import '../../services/database_service.dart';

///Returns a list tile widget which allows one to add a friend
class DiscoverFriend extends StatelessWidget {
  //Snapshot of users who are not friends of the current user
  final dynamic discoverFriendsSnapshot;
  //Index of the current non-friend of the current user on the discover friends list
  final int index;
  const DiscoverFriend(
      {required this.discoverFriendsSnapshot, required this.index});

  @override
  Widget build(BuildContext context) {
    Future<void> addFriend(String id) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      context.read<PeopleProvider>().setAddingFriend(true);
      String response = await DatabaseService().addFriend(id);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(response)));
    }

    return ListTile(
      key: Key(discoverFriendsSnapshot!.toList()[index].get('id')),
      contentPadding: const EdgeInsets.all(0),
      leading: discoverFriendsSnapshot!.toList()[index].get('photoUrl') != null
          ? ProfilePic(
              padleft: MediaQuery.of(context).size.height * 0.017,
              width: MediaQuery.of(context).size.height * 0.065,
              height: MediaQuery.of(context).size.height * 0.065,
              child: Image.network(
                discoverFriendsSnapshot!.toList()[index].get('photoUrl'),
                fit: BoxFit.cover,
              ))
          : ProfilePic(
              padleft: MediaQuery.of(context).size.height * 0.017,
              width: MediaQuery.of(context).size.height * 0.065,
              height: MediaQuery.of(context).size.height * 0.065,
              child: Image.asset(
                'assets/images/signupBackground.jpg',
                fit: BoxFit.cover,
              ),
            ),
      title: Text(
        discoverFriendsSnapshot.toList()[index].get('username'),
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.merge(const TextStyle(fontWeight: FontWeight.normal)),
      ),
      trailing: IconButton(
          onPressed: () =>
              addFriend(discoverFriendsSnapshot!.toList()[index].get('id')),
          icon: const Icon(Icons.add)),
    );
  }
}
