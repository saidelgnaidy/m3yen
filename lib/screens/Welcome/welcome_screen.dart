import 'package:flutter/material.dart';
import 'package:m3yen/components/reused.dart';
import 'package:m3yen/screens/Login/login_screen.dart';
import 'package:m3yen/screens/Signup/signup_screen.dart';
import '../../constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  TabController? ctrl ;

  @override
  void initState() {
    super.initState();
    ctrl = TabController(vsync: this, length: 3, initialIndex: 1) ;
  }

  void jumpTo({required int page}){
    ctrl!.animateTo(page, duration: Duration(milliseconds: 300), curve: Curves.decelerate ) ;
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body:  Stack(
          children: [
            TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: ctrl,
              children: [
                SignUpScreen(
                  accCheckPressed: (){
                    jumpTo(page: 2);
                  },
                ),
                Container(
                  height: size.height,
                  width: double.infinity,
                  decoration: gradientBack(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/spla.png",
                              height: size.height * 0.25,
                            ),
                            SizedBox(height: size.height * 0.1),
                            RoundedButton(
                              text: "دخول",
                              press: () {
                                jumpTo(page: 2);
                              },
                            ),
                            RoundedButton(
                              text: "حساب جديد",
                              color: kPrimaryLightColor,
                              textColor: Colors.black,
                              press: () {
                                jumpTo(page: 0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                LoginScreen(
                  accCheckPressed: (){
                    jumpTo(page: 0);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
