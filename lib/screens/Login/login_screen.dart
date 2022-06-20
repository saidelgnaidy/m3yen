import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/components/reused.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';


class LoginScreen extends StatefulWidget {

  final Function accCheckPressed ;
  const LoginScreen({required this.accCheckPressed}) ;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String?  _phone   ,_cCode, errorMSG ='';
  bool error = false , hide = true;

  loginWithPhone({required FB fb })async{
    fb.setErrorsToFalse();
    final isRegistered = await fb.checkIfAPhoneIsRegistered(phone: _phone);
    if(!isRegistered){
      setState(() {
        errorMSG = 'هذا الهاتف غير مسجل' ;
        error = true ;
      });
    }else{
      setState(() {
        error = false ;
      });
      fb.phoneAuth( phone: _phone , cCode: _cCode ,context: context , login:  true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fb = Provider.of<FB>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        decoration: gradientBack(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/spla.png", height: size.height * 0.25),
                  SizedBox(height: 40),
                  RoundedInputField(
                    hintText: "الهاتف",
                    icon: AntDesign.phone,
                    type: TextInputType.phone,
                    prefix: MyCountryCode(
                      onChanged: (code){
                        _cCode = code.dialCode ;
                      },
                      onInit: (code) {
                        _cCode = code.dialCode ;
                      },
                    ),
                    onChanged: (value) {
                      _phone = value ;
                    },
                  ),
                  error ?
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                    child: Text(errorMSG!, style: TextStyle(color: Colors.grey),),
                  ) : SizedBox(),
                  fb.fbErrorBool! ?
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                    child: Text( fb.errorMSGFromFB!, style: TextStyle(color: Colors.grey)),
                  ) : SizedBox(),
                  fb.loadingState! ? Padding(
                    padding:  EdgeInsets.only(top: 15,bottom: 10),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
                  ) : SizedBox(),
                  RoundedButton(
                    text: "دخول",
                    press: () {
                      loginWithPhone(fb: fb);
                    },
                  ),
                  SizedBox(height: 30),
                  AlreadyHaveAnAccountCheck(press: widget.accCheckPressed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
