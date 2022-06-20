import 'package:flutter/material.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'hero_dialog.dart';

class CustomDrop extends StatelessWidget {

  final String? title ;
  final IconData? icon;
  final Widget? child;
  final String? tag;
  final double? width ;
  final Color? color ;

  const CustomDrop({this.title, this.icon, this.tag, this.child, this.width, this.color}) ;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size ;

    return Hero(
      tag: tag!,
      createRectTween: (begin , end){
        return HeroTween(begin: begin, end: end);
      },
      child: Container(
        width: width ?? size.width,
        margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
        height: 50,
        decoration: BoxDecoration(
          color: color ?? kPrimaryLightColor,
          //boxShadow: shadow,
          borderRadius: BorderRadius.circular(25),
        ),
        child: RawMaterialButton(
          shape: StadiumBorder(),
          onPressed: () {
            Navigator.push(context, HeroDialog(
              builder: (context)=> child!,
              settings: RouteSettings(name: tag,),
            ));
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.ltr,
              children: [
                Icon(icon,color: Colors.transparent,size: 20),
                Text(title!,style: TextStyle(color: kPrimaryColor, fontSize: 16),),
                Icon(icon,color: Colors.green,size: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class CustomDropMini extends StatelessWidget {

  final String? title ;
  final Widget? child;
  final String? tag;


   CustomDropMini({this.title, this.tag, this.child}) ;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size ;
    final FB fb = Provider.of<FB>(context);

    return Hero(
      tag: tag!,
      createRectTween: (begin , end){
        return HeroTween(begin: begin, end: end);
      },
      child: Container(
        width: size.width*.5-5,
        margin: EdgeInsets.fromLTRB(tag == 'pickJop' ? .1 : 5, 0 , tag != 'pickJop' ? 0 : 0, 0),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight:  Radius.circular(tag == 'pickJop' ? 15 : 0)  , topLeft: Radius.circular(tag == 'pickJop' ? 0 : 15)),
        ),
        child: RawMaterialButton(
          shape: StadiumBorder(),
          onPressed: () {
            Navigator.push(context, HeroDialog(
              builder: (context)=> child!,
              settings: RouteSettings(name: tag,),
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.ltr,
            children: [
              Container(
                width: 40,
                height: 40,
                child: RawMaterialButton(
                  padding: EdgeInsets.zero,
                  shape: StadiumBorder(),
                  child: Icon(Icons.clear , color: Colors.green,size:20),
                  onPressed: () {
                    tag == 'pickJop' ? fb.changeSelectedJop(null) : fb.changeSelectedCity(null);
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(title!,
                    style: TextStyle(color: kPrimaryColor),
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

}

