import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String? uid;
  DatabaseService({this.uid});

  //reference to the collections
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //save the user data
  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  //getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

//getting user groups
  gettingUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

//creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupId": "",
      "admin": "${uid}_$userName",
      "groupIcon": "",
      "members": [],
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime": FieldValue.serverTimestamp()
    });
//updating the memebers
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

//updating the groups of user
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

//getting the chats
  Future getChat(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
  }

//getting the admin
  Future getGroupAdmin(String groupId) async {
    DocumentSnapshot dSnapshot = await groupCollection.doc(groupId).get();
    return dSnapshot["admin"];
  }

//getting the group memebers
  getGroupMemebers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

//search groups
  searchGroupByName(String groupName) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

//bool---> function
  Future<bool> isUserJoined(
      String userName, String groupId, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = documentSnapshot["groups"];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

//toggling the group join/exit
  Future toggleGroupJoin(
      String userName, String groupName, String groupId) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = documentSnapshot["groups"];
    if (groups.contains("${groupId}_${groupName}")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_${groupName}"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_${userName}"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_${groupName}"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_${userName}"])
      });
    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData["message"],
      "recentMessageSender": chatMessageData["sender"],
      "recentMessageTime": chatMessageData["time"],
    });
  }

//getting recent msg
  Future getRecentMsg(String groupId) async {
    DocumentSnapshot dSnapshot = await groupCollection.doc(groupId).get();
    return dSnapshot["recentMessage"];
  }

//getting recent msg time
  Future getRecentMsgTime(String groupId) async {
    await groupCollection.doc(groupId).get().then((values) {
      if (values.exists) {
        if (values["recentMessageTime"] == null) {
          return null;
        } else {
          return values["recentMessageTime"];
        }
      }
    });
    // if (dSnapshot.exists) {
    //   dynamic result = dSnapshot["recetnMessageTime"] == null
    //       ? null
    //       : dSnapshot["recetnMessageTime"];
    //   return result;
    // } else {
    //   return null;
    // }
  }

//getting recent msg sender name
  Future getRecentMsgSenderName(String groupId) async {
    DocumentSnapshot dSnapshot = await groupCollection.doc(groupId).get();
    return dSnapshot["recentMessageSender"];
  }
}
