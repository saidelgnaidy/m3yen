import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/animation.dart';
import 'package:m3yen/components/reused.dart';
import 'package:m3yen/screens/popups/city_Picker.dart';
import 'package:m3yen/screens/popups/custom_drop.dart';
import 'package:m3yen/screens/popups/pick_jop.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class SignUpScreen extends StatefulWidget {

  final Function accCheckPressed ;
  SignUpScreen({required this.accCheckPressed});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  String? _name   ,errorMSG = ''  , _phone  , _cCode;
  bool error = false ,hide = true  , isClient = true ;
  AccTypeEnum _accTypeEnum = AccTypeEnum.client ;

  signUpPressed({required FB fb}) async {
    if(_phone != null  && _name != null && fb.pickedCity != null  ){
      setState(() {error = false ;});
      final isRegistered = await fb.checkIfAPhoneIsRegistered(phone: _phone);
      if(isRegistered){
        setState(() {
          errorMSG = 'هذا الهاتف مستخدم' ;
          error = true ;
        });
      }else{
        await fb.phoneAuth( phone: _phone,cCode: _cCode , name: _name  , accType: _accTypeEnum.toString() ,context: context , login: false);
      }
    }else {
      setState(() {
        error = true ;
        errorMSG = 'تأكد من بياناتك' ;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fb = Provider.of<FB>(context);
    return Scaffold(
      body: Container(
        decoration: gradientBack(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/spla.png",
                  height: size.height * 0.25,
                ),
                SizedBox(height: 30),
                RoundedInputField(
                  hintText: "الاسم",
                  type: TextInputType.name,
                  icon: AntDesign.user,
                  onChanged: (value) {
                    _name  = value ;
                  },
                ),
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
                CustomDrop(
                  child: CityPicker(
                    customPickerFor: CustomPickerFor.signUp,
                  ),
                  icon: Icons.location_on_outlined,
                  title: fb.pickedCity == null ?  'اختر المدينة' : fb.pickedCity!.arName,
                  tag: 'pickCity',
                  width: size.width*.8,
                ),
                Container(
                  width: size.width*.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ToggleBTN(
                        text: "عميل",
                        color: !isClient ? kPrimaryLightColor : kPrimaryColor,
                        textColor: isClient ? kPrimaryLightColor : kPrimaryColor,
                        press: () {
                          setState(() {
                            isClient = true ;
                            _accTypeEnum = AccTypeEnum.client ;
                          });

                        },
                      ),
                      ToggleBTN(
                        text: "مقدم خدمة",
                        color: isClient ? kPrimaryLightColor : kPrimaryColor,
                        textColor: !isClient ? kPrimaryLightColor : kPrimaryColor,
                        press: () {
                          setState(() {
                            isClient = false ;
                            _accTypeEnum = AccTypeEnum.worker ;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                !isClient ?
                FadeX(
                  delay: 0.0,
                  child: CustomDrop(
                    child: JopPicker(
                      customPickerFor: CustomPickerFor.signUp,
                    ),
                    icon: Icons.work_outline_rounded,
                    title: fb.pickedJop == null ?  'اختر الخدمة' : fb.pickedJop!.arName,
                    tag: 'pickJop',
                    width: size.width*.8,
                  ),
                ): SizedBox() ,
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
                  text: "تسجيل",
                  press: () {
                    fb.setErrorsToFalse();
                    if(isClient) signUpPressed(fb: fb);
                    else if(!isClient){
                      if(fb.pickedJop != null ){
                        signUpPressed(fb: fb);
                      } else setState(() {
                        error = true ; errorMSG = 'تأكد من بياناتك' ;
                      });
                    }
                  },
                ),
                SizedBox(height: 30),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: widget.accCheckPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
