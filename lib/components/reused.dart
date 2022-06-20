import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/screens/profile/profile.dart';
import 'package:m3yen/service/firebase.dart';
import '../constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "انشاء حساب جديد   " : "دخول   ",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          login ? "ليس لديك حساب ؟ " : "لديك حساب ؟ ",
          style: TextStyle(color: Colors.green),
        ),

      ],
    );
  }
}


class RoundedButton extends StatelessWidget {
  final String? text;
  final Function? press;
  final Color color, textColor;
  RoundedButton({this.text, this.press, this.color = kPrimaryColor, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: size.width * 0.8,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      child: RawMaterialButton(
        shape: StadiumBorder(),
        onPressed: press as void Function()?,
        child: Text(text!,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

class ToggleBTN extends StatelessWidget {
  final String? text;
  final Function? press;
  final Color color, textColor ;
  const ToggleBTN({
    Key? key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      margin: EdgeInsets.only(top: 8),
      width: size.width * 0.4-5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      duration: Duration(milliseconds: 200),
      child: RawMaterialButton(
        onPressed: press as void Function()?,
        highlightColor: Colors.transparent,
        enableFeedback: false,
        child: Text(text!,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

// class RoundedPasswordField extends StatelessWidget {
//   final ValueChanged<String> onChanged;
//   final TextInputType type ;
//   final Function showPass ;
//   final bool hide ;
//   const RoundedPasswordField({
//     Key key,
//     this.onChanged, this.type, this.showPass, this.hide,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
//       width: size.width * 0.8,
//       decoration: BoxDecoration(
//         color: kPrimaryLightColor,
//         borderRadius: BorderRadius.circular(29),
//       ),
//       child: TextField(
//         obscureText: hide,
//         onChanged: onChanged,
//         keyboardType: type,
//         cursorColor: kPrimaryColor,
//         decoration: InputDecoration(
//           hintText: "كلمة المرور",
//           icon: Icon(
//             Icons.lock,
//             color: kPrimaryColor,
//           ),
//           suffixIcon: IconButton(
//             onPressed: showPass,
//             icon: Icon( hide ?  Icons.visibility : Icons.visibility_off),
//           ),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final TextInputType? type ;
  final Widget? prefix ;
  final ValueChanged<String>? onChanged;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged, this.type, this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: Color.fromRGBO(39, 105, 171, 1)),
        textAlign: TextAlign.center,
        cursorColor: kPrimaryColor,
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: type,
        decoration: InputDecoration(
          prefixIcon: prefix ?? SizedBox(width: 30,),
          suffixIcon: Icon(icon, color: Colors.green, size: 20,),
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromRGBO(39, 105, 171, 1)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class MyCountryCode extends StatelessWidget {
  final Function? onChanged , onInit;
  const MyCountryCode({this.onChanged, this.onInit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      child: CountryCodePicker(
        onChanged: onChanged as void Function(CountryCode)?,
        padding: EdgeInsets.zero,
        barrierColor: Colors.black26,
        showFlag: false,
        hideSearch: true,
        showFlagMain: false,
        textStyle: TextStyle(color: Color.fromRGBO(39, 105, 171, 1) , fontSize: 14),
        initialSelection: 'SA',
        favorite: ['SA','EG','AE','SY','OM','MC','KW','JO','IR','IQ','PS','QA','BH','YE','TN','DZ','LB','LY'],
        showFlagDialog: true,
        comparator: (a, b) => b.name!.compareTo(a.name!),
        onInit: onInit as void Function(CountryCode?)?,
      ),
    );
  }
}

Widget completeURProfile({String? uid }){
  return StreamBuilder<LocalUser>(
    stream: FB(uID: uid).userInformation,
    builder: (context, snapshot) {
      if(snapshot.hasData){
        if(snapshot.data!.certifications!.length == 0 || snapshot.data!.skills!.length == 0 && snapshot.data!.accType == AccTypeEnum.worker.toString()){
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: Material(
              color: Colors.yellowAccent,
              borderRadius: BorderRadius.all(Radius.circular(25 )),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  children: [
                    Text('اكمل بياناتك الشخصية',
                      style: TextStyle(color: Colors.red, fontSize: 15 ),
                    ),
                    SizedBox(width: 10),
                    Icon(AntDesign.notification),
                  ],
                ),
              ),
            ),
          );
        }else if((snapshot.data!.certifications!.length != 0 || snapshot.data!.skills!.length != 0 )&& !snapshot.data!.completed!){
          return Material(
            color: Colors.yellow,
            borderRadius: BorderRadius.all(Radius.circular(25 )),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Row(
                children: [
                  Text('تتم مراجعة بياناتك',
                    style: TextStyle(color: Colors.red, fontSize: 15 ),
                  ),
                  SizedBox(width: 10),
                  Icon(AntDesign.notification),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      }else return Center(child: CircularProgressIndicator());
    },
  );
}
class RadioItem {
  int? id;
  String? title;
  RadioItem({this.id, this.title});
}

class CertPic extends StatelessWidget {
  final String? url ;
  final double? radius , borderRad ;
  const CertPic({this.url, this.radius, this.borderRad});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRad ?? 20),
        color: kPrimaryLightColor,
        boxShadow: shadow,
      ),
      margin: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRad ?? 20),
        child: CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Container(
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRad ?? 20),
                color: kPrimaryLightColor,
                boxShadow: shadow,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/7374FF.gif'),
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRad ?? 20),
                color: kPrimaryLightColor,
                boxShadow: shadow,
              ),
              child: Icon(Icons.error_outline),
            );
          },
        ),
      ),
    );
  }
}

class FadeScaleAnimation extends StatelessWidget {
  final Widget child ;
  final int? duration ;
  FadeScaleAnimation({required this.child, this.duration}) ;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .8 , end: 1.0),
      duration: Duration(milliseconds: duration ??  400),
      curve: Curves.decelerate,
      builder: (context,dynamic value , child){
        return Opacity(
          opacity: (value - .8)*5,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        ) ;
      },
      child: child,
    );
  }
}
