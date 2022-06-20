import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/screens/chat/homChat.dart';
import 'package:m3yen/screens/profile/profile_brawser.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../constants.dart';


class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ required WidgetBuilder builder, RouteSettings? settings }) : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child  );
  }
}



class InfoTile extends StatelessWidget {
  final LocalUser? localUser ;
  InfoTile({ this.localUser});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MyCustomRoute(builder: (context) => ProfileBrawser(userUID: localUser!.uid,)));
      },
      child: Hero(
        tag: localUser!.uid!,
        child: Container(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: shadow,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 125,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 40,
                          child: RawMaterialButton(
                            child: Icon(AntDesign.phone, color: Colors.blue,size: 20),
                            onPressed: () => launchUrlString('tel:${localUser!.phone}'),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: RawMaterialButton(
                            child: Image.asset('assets/images/whats.png',height: 25,),
                            onPressed: () => launchUrlString('https://api.whatsapp.com/send?phone=${localUser!.cCode}${localUser!.phone}'),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: RawMaterialButton(
                            child: Icon(AntDesign.message1, color: Colors.blue,size: 20),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> Chat(localUser: localUser,))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 125, width: .5,
                    child: VerticalDivider(thickness: .5, color: Colors.black26),
                  ),
                ],
              ),
              Container(
                height: 125,
                width: size.width - size.width*.26 - 65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(AntDesign.user, color: Colors.orangeAccent,size: 20),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(localUser!.name ?? '',
                            textDirection: TextDirection.rtl,
                            style: TextStyle( fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        localUser!.completed! ?
                        Icon(Icons.check_circle ,size: 15, color: Colors.blue,): SizedBox(),
                      ],
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.work_outline_rounded, color: Colors.blue,size: 20,),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(localUser!.jobFromFB!.arName ?? '',
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.green,size: 20,),
                        SizedBox(width: 20),
                        Text(localUser!.cityFromFB!.arName ?? '',
                          style: TextStyle( color: Colors.black87),
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.history_toggle_off_rounded, color: Colors.blue,size: 20),
                        SizedBox(width: 20),
                        Text(localUser!.free! ? 'متفرغ' : "يعمل",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width*.26,
                height: 125,
                child: pic(url: localUser!.picUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget pic({String? url}){
  if(url == ''){
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/images/profile2.png'),
        ),
      ),
    );
  }else
  return ClipRRect(
    borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
    child: CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Container(
          height: 130,
          width: 100,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/7374FF.gif'),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          height: 130,
          width: 100,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/profile2.png'),
            ),
          ),
        );
      }
    ),
  );

}
