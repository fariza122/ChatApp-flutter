import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';

class ProfilePage extends StatefulWidget {
  String email;
  String userName;
  ProfilePage({required this.email, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().backgroundColor,
        toolbarHeight: 70,
        title: const Text(
          "Profile",
          style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 248, 230, 230)),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: drawerWidget(authService, widget.email, widget.userName,
          "ProfilePage", context, true, Constants().primaryColor),
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(55.0), topRight: Radius.circular(55.0)),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'assets/chatAppLogo.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Full Name",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Constants().backgroundColor),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Constants().primaryColor,
                          border: Border.all(color: Constants().primaryColor),
                          borderRadius: BorderRadius.circular(28)),
                      child: Text(
                        widget.userName,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Constants().backgroundColor),
                      ))
                ],
              ),
              const Divider(
                height: 50,
                color: Color.fromARGB(255, 248, 230, 230),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Constants().backgroundColor),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Constants().primaryColor,
                          border: Border.all(color: Constants().primaryColor),
                          borderRadius: BorderRadius.circular(28)),
                      child: Text(
                        widget.email,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Constants().backgroundColor),
                      ))
                ],
              )
            ]),
      ),
    );
  }
}
