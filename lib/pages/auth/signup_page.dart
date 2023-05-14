import 'package:chat_app_with_firebase/helper/helper_func.dart';
import 'package:chat_app_with_firebase/pages/auth/login_page.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import '../home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
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
              // const SizedBox(
              //   height: 10,
              // ),
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
              const Text("Create your account now to chat and explore",
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
                  height: 200,
                ),
              ),
              TextFormField(
                style:
                    const TextStyle(color: Color.fromARGB(255, 248, 230, 230)),
                decoration: inputFieldDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Constants().primaryColor,
                    )),
                validator: (val) {
                  if (val!.isNotEmpty) {
                    return null;
                  } else {
                    return "Name can't be empty";
                  }
                },
                onChanged: (val) {
                  setState(() {
                    fullName = val;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                style:
                    const TextStyle(color: Color.fromARGB(255, 248, 230, 230)),
                // keyboardType: TextInputType.emailAddress,
                decoration: inputFieldDecoration.copyWith(
                    fillColor: Colors.white,
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
                      register();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Constants().primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text("Sign-up",
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
        "Already have an account?",
        style: TextStyle(
            fontSize: 13,
            // fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      TextButton(
        onPressed: () {
          nextScreen(context, const LoginPage());
        },
        child: Text(
          'Login Now',
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
            color: Theme.of(context).primaryColor,
          ))
        : backgroundContent(mainContent, bottomNavWidget);
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preferences state
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserNameInSF(fullName);
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
