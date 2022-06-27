import 'package:flutter/material.dart';
import 'package:whim_chat/src/core/models/user.dart' as model;
import 'package:whim_chat/src/core/screens/views/conversation_view.dart';

class ChatView extends StatefulWidget {
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
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
                                borderSide:
                                    BorderSide(width: 0.5, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          //This is for background color
                          color: Colors.white.withOpacity(0.0),

                          //This is for bottom border that is needed
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
                      Expanded(
                          child: ListView.separated(
                        itemCount: users().length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConversationView())),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: MediaQuery.of(context).size.height *
                                        0.06,
                                    backgroundImage: NetworkImage(
                                      users()[index].photoUrl,
                                    )),
                                title: Text(
                                  users()[index].username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.merge(const TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ),
                                trailing: Text('10:00'),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          // return SizedBox(
                          //   height: 10,
                          // );
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Divider(
                              thickness: 0.2,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )),
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
