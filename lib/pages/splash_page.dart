import 'package:flutter/material.dart';
import '../helper/helper_func.dart';
import '../widgets/widgets.dart';
import 'home_page.dart';
import 'auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _signedIn = false;

  @override
  void initState() {
    start_Timer();
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _signedIn = value;
        });
      }
    });
  }

  start_Timer() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // LoginPage()
                  _signedIn ? const HomePage() : const LoginPage()));
    });
  }

  Widget mainContent() {
    return Column(
      children: [
        const SizedBox(
          height: 90,
        ),
        Container(
          // color: Colors.black,
          height: 300,
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/chatAppLogo.png",
              fit: BoxFit.fill,
              // height: 300,
            ),
          ),
        ),
        const Text(
          "Walkie",
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  backgroundNavWidget() {
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return backgroundContent(mainContent, backgroundNavWidget);
    //  Scaffold(
    //     body: Column(children: [
    //       Container(
    //           width: 70,
    //           height: 70,
    //           child: CustomPaint(
    //             painter: OpenPainter2(),
    //           )),
    //       const SizedBox(
    //         height: 90,
    //       ),

    //       Container(
    //         // color: Colors.black,
    //         height: 300,
    //         padding: EdgeInsets.symmetric(vertical: 0.0),
    //         child: Align(
    //           alignment: Alignment.bottomCenter,
    //           child: Image.asset(
    //             "assets/chatAppLogo.png",
    //             fit: BoxFit.fill,
    //             // height: 300,
    //           ),
    //         ),
    //       ),
    //       const Text(
    //         "Walkie",
    //         style: TextStyle(
    //             fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
    //       ),
    //       //   ],
    //       // )
    //       // ),
    //     ]),
    //     bottomNavigationBar: BottomAppBar(
    //         color: Constants().backgroundColor,
    //         child: Container(
    //           width: double.infinity,
    //           height: 200,
    //           child: CustomPaint(
    //             painter: OpenPainter(),
    //           ),
    //         )));
  }
}
