import 'package:flutter/material.dart';

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
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          //This is for background color
                          color: Colors.white.withOpacity(0.0),

                          //This is for bottom border that is needed
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: TabBar(
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
                      Center(
                        child: Text('Private'),
                      ),
                      Center(
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
