import 'package:chat_app_with_firebase/pages/home_page.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helper_func.dart';
import '../shared/constants.dart';
import '../widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {required this.groupId,
      required this.groupName,
      required this.adminName});
  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  String userName = "";

  @override
  void initState() {
    getMembers();
    gettingData();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMemebers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  gettingData() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
        // QuerySnapshot snapshot =
        //      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        //         .gettingUserData(email);
        // userName = snapshot.docs[0]["fullName"];
        // groups = snapshot.docs[0]["gorups"];
        // profilePic = snapshot.docs[0]["profilePic"];
      });
    });
  }

//string manipulation
  String getUserId(String combo) {
    return combo.substring(0, combo.indexOf("_"));
  }

  String getName(String combo) {
    return combo.substring(combo.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().backgroundColor,
        toolbarHeight: 70,
        elevation: 0,
        title: const Text(
          "Group Info",
          style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 248, 230, 230)),
        ),
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  // barrierColor: Constants().backgroundColor,
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Constants().backgroundColor,
                      title: const Text(
                        "Exit",
                      ),
                      titleTextStyle: TextStyle(
                        fontSize: 22,
                        color: Constants().primaryColor,
                      ),
                      content: const Text(
                        "Are you sure! you want to exit the group?",
                      ),
                      contentTextStyle: TextStyle(
                        fontSize: 16,
                        color: Constants().primaryColor,
                      ),
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 1.0)),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            elevation: 0,
                          ),
                          child: const Text(
                            "cancel",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .toggleGroupJoin(getName(userName),
                                    widget.groupName, widget.groupId)
                                .whenComplete(() {
                              nextScreenReplace(context, HomePage());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Constants().primaryColor,
                            elevation: 0,
                          ),
                          child: const Text(
                            "Ok",
                          ),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.exit_to_app,
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
              topLeft: Radius.circular(55.0), topRight: Radius.circular(55.0)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Constants().backgroundColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(children: [
                  CircleAvatar(
                    backgroundColor: Constants().primaryColor.withOpacity(0.5),
                    radius: 23,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Flexible(
                      //   flex:4,
                      //   child:
                      Text(
                        "Group : ${widget.groupName}",
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Constants().backgroundColor),
                      ),
                      // ),
                      const SizedBox(
                        height: 4,
                      ),
                      // Flexible(
                      //   fit: FlexFit.loose,
                      //   child:
                      Text("Admin : ${widget.adminName}",
                          softWrap: true, style: const TextStyle(fontSize: 13)),
                      // ),
                    ],
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Members",
                    style: TextStyle(
                        color: Constants().backgroundColor,
                        fontSize: 21,
                        fontWeight: FontWeight.bold)),
              ),
              Divider(
                height: 5,
                color: Constants().primaryColor.withOpacity(0.5),
              ),
              membersList(),
            ]),
      ),
    );
  }

  membersList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length != 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data["members"].length,
                    itemBuilder: (context, index) {
                      String OnlyNameOfMember =
                          getName(snapshot.data["members"][index]);
                      return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Constants().backgroundColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Constants().primaryColor.withOpacity(0.5),
                              radius: 23,
                              child: Text(
                                OnlyNameOfMember.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Expanded(
                              // flex: 2,
                              child: Text(
                                // textHeightBehavior : TextHeightBehavior(),
                                getName(snapshot.data["members"][index]),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Constants().backgroundColor),
                              ),
                            ),
                            subtitle:
                                Text(getUserId(snapshot.data["members"][index]),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.7,
                                    )),
                          ));
                    });
              } else {
                return Center(
                  child: Text("No Members",
                      style: TextStyle(
                        color: Constants().backgroundColor,
                        fontSize: 24,
                        decoration: TextDecoration.underline,
                      )),
                );
              }
            } else {
              return Center(
                child: Text("No Members",
                    style: TextStyle(
                      color: Constants().backgroundColor,
                      fontSize: 24,
                      decoration: TextDecoration.underline,
                    )),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Constants().backgroundColor,
              ),
            );
          }
        });
  }
}
