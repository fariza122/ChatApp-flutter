import 'package:chat_app_with_firebase/pages/auth/signup_page.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_func.dart';
import '../../shared/constants.dart';
import '../../widgets/widgets.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isloading = false;
  AuthService authService = AuthService();

  mainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 28,
              ),
              const Text(
                "Walkie",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Login now to see what they are talking",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 125, 145, 175),
                  )),
              Container(
                width: double.infinity,
                child: Image.asset(
                  "assets/chatAppLogo.png",
                  // width: 250,
                  height: 220,
                ),
              ),
              TextFormField(
                style:
                    const TextStyle(color: Color.fromARGB(255, 248, 230, 230)),
                decoration: inputFieldDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Constants().primaryColor,
                    )),
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },

                //check the validation
                validator: (val) {
                  return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                      ? null
                      : "Please enter a valid email";
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                obscureText: true,
                style:
                    const TextStyle(color: Color.fromARGB(255, 248, 230, 230)),
                decoration: inputFieldDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Constants().primaryColor,
                    )),
                validator: (val) {
                  if (val!.length < 6) {
                    return "Password must have atleast 6 characters";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Constants().primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text("Sign-in",
                        style: TextStyle(
                          color: Constants().backgroundColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        )),
                  )),
            ],
          )),
    );
  }

  bottomNavWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        "New User?",
        style: TextStyle(
            fontSize: 13,
            // fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      TextButton(
        onPressed: () {
          nextScreen(context, const SignupPage());
        },
        child: Text(
          'Sign Up',
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Constants().primaryColor),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor))
        : backgroundContent(mainContent, bottomNavWidget);

    //     Scaffold(
    //   body: Column(
    //     children: [
    //       Align(
    //           // alignment: Alignment.topRight,
    //           child: Container(
    //               width: 70,
    //               height: 70,
    //               child: CustomPaint(
    //                 painter: OpenPainter2(),
    //               ))
    //           //  Transform.scale(
    //           //   scale: 1.9,
    //           //   child: Container(
    //           //       width: 110,
    //           //       height: 110,
    //           //       decoration: BoxDecoration(
    //           //         borderRadius: BorderRadius.circular(200),
    //           //         color: const Color.fromARGB(255, 20, 45, 83),
    //           //       )),
    //           // ),
    //           ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    //         child: Form(
    //             key: formKey,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 const SizedBox(
    //                   height: 28,
    //                 ),
    //                 const Text(
    //                   "Walkie",
    //                   style: TextStyle(
    //                       fontSize: 40,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.white),
    //                 ),
    //                 const SizedBox(
    //                   height: 10,
    //                 ),
    //                 const Text("Login now to see what they are talking",
    //                     style: TextStyle(
    //                       fontSize: 13,
    //                       fontWeight: FontWeight.bold,
    //                       color: Color.fromARGB(255, 125, 145, 175),
    //                     )),
    //                 Container(
    //                   width: double.infinity,
    //                   child: Image.asset(
    //                     "assets/chatAppLogo.png",
    //                     // width: 250,
    //                     height: 220,
    //                   ),
    //                 ),
    //                 TextFormField(
    //                   decoration: inputFieldDecoration.copyWith(
    //                       labelText: "Email",
    //                       prefixIcon: Icon(
    //                         Icons.email,
    //                         color: Constants().primaryColor,
    //                       )),
    //                 ),
    //                 const SizedBox(
    //                   height: 15,
    //                 ),
    //                 TextFormField(
    //                   decoration: inputFieldDecoration.copyWith(
    //                       labelText: "Password",
    //                       prefixIcon: Icon(
    //                         Icons.lock,
    //                         color: Constants().primaryColor,
    //                       )),
    //                 ),
    //                 SizedBox(height: 18),
    //                 SizedBox(
    //                     width: double.infinity,
    //                     height: 50,
    //                     child: ElevatedButton(
    //                       onPressed: () {},
    //                       style: ElevatedButton.styleFrom(
    //                           primary: Constants().primaryColor,
    //                           elevation: 0,
    //                           shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(30))),
    //                       child: Text("Sign-in",
    //                           style: TextStyle(
    //                             color: Constants().backgroundColor,
    //                             fontSize: 24,
    //                             fontWeight: FontWeight.w500,
    //                           )),
    //                     )),
    //               ],
    //             )),
    //       ),
    //     ],
    //   ),
    //   bottomNavigationBar: BottomAppBar(
    //     color: Constants().backgroundColor,
    //     child: Container(
    //       width: double.infinity,
    //       height: 200,
    //       child: CustomPaint(
    //         painter: OpenPainter(),
    //         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    //           const Text(
    //             "New User?",
    //             style: TextStyle(
    //                 fontSize: 13,
    //                 // fontWeight: FontWeight.bold,
    //                 color: Colors.white),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               nextScreen(context, const SignupPage());
    //             },
    //             child: Text(
    //               'Sign Up',
    //               style: TextStyle(
    //                   decoration: TextDecoration.underline,
    //                   fontSize: 13,
    //                   fontWeight: FontWeight.bold,
    //                   color: Constants().primaryColor),
    //             ),
    //           ),
    //         ]),
    //       ),
    //     ),
    //   ),
    // );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authService
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          // saving the data to shared preferences
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserNameInSF(snapshot.docs[0]["fullName"]);
          await HelperFunction.saveUserEmailInSF(email);

          //directing to home page
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }
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
        const Offset(-80, 60) & const Size(650, 600),
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
