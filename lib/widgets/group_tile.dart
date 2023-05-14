import 'package:chat_app_with_firebase/pages/chat_page.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../shared/constants.dart';

class GroupTile extends StatefulWidget {
  String groupName;
  String groupId;
  String userName;

  GroupTile({
    required this.groupId,
    required this.groupName,
    required this.userName,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  String recentMessage = "";
  String senderName = "";
  dynamic msgTime = "";

  @override
  void initState() {
    getRecentMsgAndSenderName();
    super.initState();
  }

  getRecentMsgAndSenderName() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getRecentMsg(widget.groupId)
        .then((value) {
      setState(() {
        recentMessage = value;
      });
    });
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getRecentMsgSenderName(widget.groupId)
        .then((value) {
      setState(() {
        senderName = value;
      });
    });
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getRecentMsgTime(widget.groupId)
        .then((value) {
      setState(() {
        msgTime =
            value == null ? "" : DateFormat("hh:mm a").format(value.toDate());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          nextScreen(
              context,
              ChatPage(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  userName: widget.userName));
        },
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Color.fromARGB(255, 220, 215, 215),
            width: 0.5,
          ))),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListTile(
              isThreeLine: false,
              leading: CircleAvatar(
                backgroundColor: Constants().backgroundColor,
                radius: 35,
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 248, 230, 230),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                widget.groupName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  //  Expanded(
                  //     child:
                  Text(
                      recentMessage == ""
                          ? "Start the conversation as ${widget.userName}"
                          : senderName == widget.userName
                              ? "You: ${recentMessage} "
                              : "${senderName}: ${recentMessage} ",
                      softWrap: true,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 13))),

          // )
        )
        // : Container();
        // })
        );
  }
}
