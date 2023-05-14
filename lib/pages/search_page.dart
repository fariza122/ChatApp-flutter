import 'package:chat_app_with_firebase/helper/helper_func.dart';
import 'package:chat_app_with_firebase/pages/chat_page.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';

class SearchPage extends StatefulWidget {
  String userName;
  SearchPage({Key? key, required this.userName}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchedGroupName = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  // String userName = "";
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserNameAndId();
  }

  getUserNameAndId() async {
    // await HelperFunction.getUserNameFromSF().then((value) {
    //   setState(() {
    //     userName = value!;
    //   });
    // });
    user = FirebaseAuth.instance.currentUser;
  }

//string manipulation
  String getId(String combo) {
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
          toolbarHeight: 90,
          title: const Text(
            "Search",
            style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 248, 230, 230)),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(54),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  children: [
                    // Align(
                    //     alignment: Alignment.bottomLeft,
                    //     child:
                    Expanded(
                      child: TextField(
                        controller: searchedGroupName,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search groups....",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 248, 230, 230)
                                .withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        initiateSearching();
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Constants().primaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              )),
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55.0),
                topRight: Radius.circular(55.0)),
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Constants().backgroundColor,
                  ),
                )
              : groupList(),
        ));
  }

  initiateSearching() async {
    if (searchedGroupName.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchGroupByName(searchedGroupName.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  widget.userName,
                  searchSnapshot!.docs[index]["groupName"],
                  searchSnapshot!.docs[index]["groupId"],
                  searchSnapshot!.docs[index]["admin"]);
            })
        : Container();
  }

  joinedOrNot(
      String groupname, String groupId, String username, String admin) async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .isUserJoined(username, groupId, groupname)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupName, String groupId, String admin) {
    joinedOrNot(groupName, groupId, userName, admin);
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Constants().backgroundColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListTile(
          // contentPadding: EdgeInsets.symmetric(vertical: 2),
          leading: CircleAvatar(
            backgroundColor: Constants().primaryColor.withOpacity(0.5),
            radius: 23,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            // textHeightBehavior : TextHeightBehavior(),
            groupName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Constants().backgroundColor),
          ),
          subtitle: Text("Admin: ${getName(admin)}",
              style: const TextStyle(
                fontSize: 13,
                height: 1.7,
              )),
          trailing: InkWell(
              onTap: () async {
                await DatabaseService(
                        uid: FirebaseAuth.instance.currentUser!.uid)
                    .toggleGroupJoin(widget.userName, groupName, groupId);
                if (isJoined) {
                  setState(() {
                    isJoined = !isJoined;
                    searchedGroupName.clear();
                  });
                  showSnackBar(
                      context, Colors.green, "Successfully joined the group!!");
                  Future.delayed(const Duration(seconds: 2), () {
                    nextScreen(
                        context,
                        ChatPage(
                            groupId: groupId,
                            groupName: groupName,
                            userName: userName));
                  });
                } else {
                  setState(() {
                    isJoined = !isJoined;
                    showSnackBar(
                        context, Colors.red, "Left the group $groupName!!");
                  });
                }
              },
              child: isJoined == true
                  ? Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Constants().backgroundColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Joined",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        // color: Constants().backgroundColor,
                        border: Border.all(
                            width: 2, color: Constants().primaryColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Join Now",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Constants().backgroundColor,
                        ),
                      ),
                    )),
        ));
  }
}
