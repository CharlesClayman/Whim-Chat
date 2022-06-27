import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/providers/people_provider.dart';

class ConversationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                backgroundColor: Colors.grey,
                //  radius: MediaQuery.of(context).size.height * 0.04,
                backgroundImage: NetworkImage(
                  peopleProvider.photoUrl,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Column(
              children: [
                Text(peopleProvider.username,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.merge(const TextStyle(color: Colors.white))),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.004,
                ),
                Text(
                  'Online',
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
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: const ShapeDecoration(
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                      child: TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  )),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.send))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
