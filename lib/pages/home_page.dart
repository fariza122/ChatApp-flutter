import 'package:chat_app_with_firebase/helper/helper_func.dart';
import 'package:chat_app_with_firebase/pages/profile_page.dart';
import 'package:chat_app_with_firebase/pages/search_page.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:chat_app_with_firebase/shared/constants.dart';
import 'package:chat_app_with_firebase/widgets/group_tile.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  dynamic groups = [];
  String profilePic = "";
  Stream? groupsFromDB;
  bool isloading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingData();
  }

  gettingData() async {
    await HelperFunction.getEmailFromSF().then((value) {
      setState(() {
        email = value!;
        // QuerySnapshot snapshot =
        //      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        //         .gettingUserData(email);
        // userName = snapshot.docs[0]["fullName"];
        // groups = snapshot.docs[0]["gorups"];
        // profilePic = snapshot.docs[0]["profilePic"];
      });
    });
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    //getting the list of snapshot in our streams
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserGroups()
        .then((snapshot) {
      setState(() {
        groupsFromDB = snapshot;
      });
    });
  }

  String getGroupId(String combo) {
    return combo.substring(0, combo.indexOf("_"));
  }

  String getGroupName(String combo) {
    return combo.substring(combo.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().backgroundColor,
        toolbarHeight: 100,
        title: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.asset(
              'assets/chatAppLogo.png',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Groups",
                style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 248, 230, 230)),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, SearchPage(userName: userName));
              },
              icon: const Icon(
                Icons.search_outlined,
                color: Color.fromARGB(255, 248, 230, 230),
              ))
        ],
      ),
      drawer: drawerWidget(authService, email, userName, "GroupPage", context,
          true, Constants().primaryColor),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(55.0), topRight: Radius.circular(55.0)),
        ),
        child: groupList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popupDialog(context);
        },
        backgroundColor: Constants().backgroundColor,
        child: const Icon(
          Icons.add,
          size: 35,
          color: Color.fromARGB(255, 248, 230, 230),
        ),
      ),
    );
  }

  groupList() {
    return StreamBuilder(
        stream: groupsFromDB,
        builder: (context, AsyncSnapshot snapshot) {
          //apply some checks
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data["groups"].length,
                    itemBuilder: (context, index) {
                      int reverseIndex =
                          snapshot.data["groups"].length - index - 1;
                      return GroupTile(
                        groupId:
                            getGroupId(snapshot.data["groups"][reverseIndex]),
                        groupName:
                            getGroupName(snapshot.data["groups"][reverseIndex]),
                        userName: snapshot.data["fullName"],
                      );
                    });
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Constants().backgroundColor,
              backgroundColor: const Color.fromARGB(255, 248, 230, 230),
            ));
          }
        });
  }

  popupDialog(BuildContext context) {
    showDialog(
        // barrierColor: Constants().backgroundColor,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              backgroundColor: Constants().backgroundColor,
              title: const Text(
                "Create a Group",
              ),
              titleTextStyle: const TextStyle(
                fontSize: 22,
                color: Color.fromARGB(255, 248, 230, 230),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isloading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Constants().backgroundColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: TextStyle(
                              color: Color.fromARGB(255, 248, 230, 230)),
                          decoration: inputFieldDecoration.copyWith(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants().primaryColor,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(20))),
                        )
                ],
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Constants().primaryColor, width: 1)),
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
                    if (groupName != "") {
                      setState(() {
                        isloading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        isloading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(context, Constants().primaryColor,
                          "Group is created Successfully");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Constants().primaryColor,
                    elevation: 0,
                  ),
                  child: const Text(
                    "Create",
                  ),
                ),
              ],
            );
          }));
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
                // alignment: Alignment.topCenter,
                onPressed: () {
                  popupDialog(context);
                },
                icon: Icon(
                  Icons.add_circle,
                  color: Constants().primaryColor,
                  size: 70,
                )),
            const SizedBox(
              height: 50,
            ),
            Text(
              "You've not joined any groups, tap on the add icon to create a group or also search from the top searhc button.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Constants().backgroundColor,
              ),
            )
          ]),
    );
  }
}
