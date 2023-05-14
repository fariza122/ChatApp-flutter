import 'package:chat_app_with_firebase/pages/group_info.dart';
import 'package:chat_app_with_firebase/pages/home_page.dart';
import 'package:chat_app_with_firebase/widgets/group_tile.dart';
import 'package:chat_app_with_firebase/widgets/message_tile.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service/database_service.dart';
import '../shared/constants.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {required this.groupId, required this.groupName, required this.userName});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  TextEditingController messagesController = TextEditingController();

  @override
  void initState() {
    getAdminAndChat();
    // TODO: implement initState
    super.initState();
  }

  getAdminAndChat() {
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });

    DatabaseService().getChat(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
  }

//string manipulation
  String getGroupId(String combo) {
    return combo.substring(0, combo.indexOf("_"));
  }

  String getAdminName(String combo) {
    return combo.substring(combo.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants().backgroundColor,
          toolbarHeight: 70,
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color.fromARGB(255, 248, 230, 230),
                radius: 20,
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: Constants().backgroundColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  widget.groupName,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 18),
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: getAdminName(admin)));
              },
              icon: const Icon(
                Icons.info,
                color: Color.fromARGB(255, 248, 230, 230),
              ),
              iconSize: 30,
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55.0),
                topRight: Radius.circular(55.0)),
          ),
          child: Stack(
            children: [
              Container(
                // decoration: BoxDecoration(
                //     border: Border.all(width: 2, color: Colors.red)),
                height: 660,
                child: chatMessages(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  // height: 50,
                  decoration: const BoxDecoration(
                      // color: Colors.white,
                      border: Border(
                          top: BorderSide(
                              color: Color.fromARGB(255, 206, 196, 196)))),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        keyboardType: TextInputType.multiline,
                        controller: messagesController,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 124, 123, 123),
                            fontSize: 17),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Write a message...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 201, 191, 191))),
                      )),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMsg();
                          setState(() {
                            HomePage();
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Constants().backgroundColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: Icon(
                            Icons.send,
                            size: 20,
                            color: Constants().primaryColor.withOpacity(0.8),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    final Time = snapshot.data.docs[index]["time"];
                    dynamic serverTime = Time == null
                        ? ""
                        : DateFormat("hh:mm a")
                            .format(Time.toDate())
                            .toString();
                    return MessageTile(
                        message: snapshot.data.docs[index]["message"],
                        sender: snapshot.data.docs[index]["sender"],
                        // time : snapshot.data.docs[index]["time"].toDate(),
                        time: serverTime,
                        sentByMe: widget.userName ==
                            snapshot.data.docs[index]["sender"]);
                  })
              : Container();
        });
  }

  sendMsg() {
    if (messagesController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messagesController.text,
        "sender": widget.userName,
        "time": FieldValue.serverTimestamp(),
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messagesController.clear();
      });
    }
  }
}
