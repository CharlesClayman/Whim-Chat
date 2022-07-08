import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/providers/people_provider.dart';
import 'package:whim_chat/src/core/screens/views/conversation_view.dart';
import 'package:whim_chat/src/core/screens/views/private_chat.dart';

class ChatView extends StatefulWidget {
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30, top: 30),
                        child: Text(
                          'Chat',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 20, top: 5, right: 20),
                        child: TextField(
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    width: 0.5, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.5))),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.0),
                          border: const Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const TabBar(
                          tabs: [
                            Tab(
                              text: 'Private Chat',
                            ),
                            Tab(
                              text: 'Group Chat',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                    child: TabBarView(children: [
                      PrivateChat(),
                      const Center(
                        child: Text('Group'),
                      ),
                    ]),
                  )
                ],
              )),
        )
      ],
    );
  }
}
