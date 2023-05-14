import 'package:flutter/material.dart';

import '../pages/auth/login_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../service/auth_service.dart';
import '../shared/constants.dart';

final inputFieldDecoration = InputDecoration(
    labelStyle: const TextStyle(
        color: Color.fromARGB(255, 248, 230, 230), fontWeight: FontWeight.w300),
    // fillColor: Colors.white,
    focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 125, 145, 175), width: 2)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Constants().primaryColor, width: 2)),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)));

Widget backgroundContent(dynamic mainContent, dynamic bottomNavWidget) {
  return Scaffold(
      body: Column(children: [
        Container(
            // color: Colors.red,
            width: 70,
            height: 50,
            child: CustomPaint(
              painter: OpenPainter2(),
            )),
        mainContent(),
        // ),
      ]),
      bottomNavigationBar: BottomAppBar(
          color: Constants().backgroundColor,
          child: Container(
            // color: Colors.red,
            width: double.infinity,
            height: 130,
            child: CustomPaint(
              painter: OpenPainter(),
              child: bottomNavWidget(),
            ),
          )));
}

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromARGB(255, 20, 45, 83)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    //draw arc
    canvas.drawArc(
        const Offset(-80, 4) & const Size(650, 600),
        3.7, //radians
        2, //radians
        true,
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class OpenPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint2 = Paint()
      ..color = const Color.fromARGB(255, 20, 45, 83)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    //draw arc
    canvas.drawArc(
        const Offset(180, -180) & const Size(400, 350),
        1.4, //radians
        2, //radians
        true,
        paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, messege) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        messege,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}

Widget drawerWidget(
    AuthService authService,
    String email,
    String username,
    String pageName,
    BuildContext context,
    bool isSelected,
    Color selectedColor) {
  return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        // padding: EdgeInsets.symmetric(vertical: 50),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            width: 300,
            height: 210,
            color: Constants().backgroundColor,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/chatAppLogo.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    username,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 248, 230, 230)),
                  )
                ]),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(context, const HomePage());
            },
            selectedColor: pageName == "GroupPage" ? selectedColor : null,
            selected: pageName == "GroupPage" ? isSelected : false,
            // Theme.of(context).primaryColor,
            // tileColor: Constants().primaryColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            leading: const Icon(
              Icons.group,
            ),
            title: Text(
              "Groups",
              style:
                  TextStyle(fontSize: 19, color: Constants().backgroundColor),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(
                  context, ProfilePage(userName: username, email: email));
            },
            selectedColor: pageName == "ProfilePage" ? selectedColor : null,
            selected: pageName == "ProfilePage" ? isSelected : false,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            leading: const Icon(
              Icons.person,
            ),
            title: Text(
              "Profile",
              style:
                  TextStyle(fontSize: 19, color: Constants().backgroundColor),
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  // barrierColor: Constants().backgroundColor,
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Constants().backgroundColor,
                      title: const Text(
                        "Logout",
                      ),
                      titleTextStyle: TextStyle(
                        fontSize: 22,
                        color: Constants().primaryColor,
                      ),
                      content: const Text(
                        "Are you sure! you want to logout?",
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
                          onPressed: () {
                            authService.signOut().whenComplete(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                              // nextScreen(context, const LoginPage());
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
            // shape: RoundedRectangleBorder(
            //     side: BorderSide(
            //         color: Constants().primaryColor, width: 1.0)),
            // selectedColor: Theme.of(context).primaryColor,
            // selected: true,
            // tileColor: Constants().primaryColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            leading: const Icon(
              Icons.logout,
            ),
            title: Text(
              "Logout",
              style:
                  TextStyle(fontSize: 19, color: Constants().backgroundColor),
            ),
          )
        ],
      ));
}
