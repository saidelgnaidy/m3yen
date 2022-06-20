import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/constants.dart';
import 'package:m3yen/screens/chat/homChat.dart';
import 'package:m3yen/screens/profile/profile.dart';
import 'package:m3yen/screens/chat/conversations_list.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';
import 'settings.dart';


class DrawerBody extends StatefulWidget {
  final String root ;

  DrawerBody({required this.root});
  @override
  _DrawerBodyState createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {

  String adminUID = 'iIx13OQxfBRvbdJUjkWPhyuOxTy1' ;


  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final FB fb = Provider.of<FB>(context);
    return Container(
      decoration: gradientBack(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child:StreamBuilder<LocalUser>(
                stream: FB(uID: user.uid).userInformation,
                builder: (context, snapshot) {
                if(snapshot.hasData){
                return ListView(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top +25,right: 20),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          maxRadius: 40,
                          backgroundImage: (snapshot.data!.picUrl == '' ?
                          AssetImage('assets/images/profile.png',) : CachedNetworkImageProvider(snapshot.data!.picUrl!)) as ImageProvider<Object>?,
                        ),
                        SizedBox(height: 10),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(snapshot.data!.name ?? "name",
                                style: TextStyle(color: Colors.white,fontSize: 18),textDirection: TextDirection.rtl
                            ),
                            SizedBox(width: 8),
                            snapshot.data!.accType == 'admin' ?
                            Text("( Admin )",
                                style: TextStyle(color: Colors.white,fontSize: 15),textDirection: TextDirection.rtl
                            ): SizedBox(),
                            SizedBox(width: 8),
                            snapshot.data!.completed! ?
                            Icon(Icons.check_circle ,size: 15, color: Colors.lightBlue,): SizedBox(),

                          ],
                        ),
                        SizedBox(height: 5),
                        Text(snapshot.data!.phone?? "phone",
                            style: TextStyle(color: Colors.white,),textDirection: TextDirection.rtl
                        ),
                        SizedBox(height:30)
                      ],
                    ),
                    DrawerTile(
                      onTap: (){
                        Navigator.pop(context);
                        if(widget.root == 'profile')
                          Navigator.pop(context);
                      },
                      icon: AntDesign.home,
                      title: 'الرئيسية',
                      leading: widget.root == 'home' ?
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ):SizedBox(),
                    ),
                    snapshot.data!.accType == AccTypeEnum.worker.toString() ?
                    DrawerTile(
                      onTap: (){
                        Navigator.pop(context);
                        if(widget.root == 'home')
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>ProfileScreen())) ;
                      },
                      icon: AntDesign.user,
                      title: 'الصفحة الشخصية',
                      leading: widget.root == 'profile' ?
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ):SizedBox(),
                    ):
                    SizedBox(),
                    DrawerTile(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>ConversationsList()));
                      },
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'المحادثات',
                      leading: StreamBuilder<QuerySnapshot>(
                        stream: FB().checkUnSeenMsg,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            if(snapshot.data!.docs.length>0){
                              return Container(
                                margin: EdgeInsets.only(left: 25),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellowAccent,
                                ),
                              ) ;
                            }else return SizedBox();
                          }
                          else return SizedBox() ;
                        },
                      ),
                    ),
                    snapshot.data!.accType != 'admin' ?
                    DrawerTile(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> Chat(
                            localUser: LocalUser(
                              uid: adminUID,
                              picUrl: ''
                            ),
                          ),
                        ));
                      },
                      icon: Icons.support_agent_rounded,
                      title: 'الدعم',
                    ):SizedBox(),
                    ExpansionTile(
                      title: Text('الاعدادات',style: TextStyle(color: Colors.white),textDirection: TextDirection.rtl),
                      trailing: Icon(AntDesign.setting,color: Colors.white),
                      leading: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white),
                      ),
                      childrenPadding: EdgeInsets.only(right: 40),
                      tilePadding: EdgeInsets.zero,
                      children: [
                        DrawerTile(
                          onTap: ()=> termsOfUseDialog(context),
                          icon: Icons.format_list_bulleted_rounded,
                          title: 'الشروط و الاحكام',
                        ),
                        DrawerTile(
                          onTap: ()=> policyDialog(context),
                          icon: Icons.policy_outlined,
                          title: 'سياسة الخصوصية',
                        ),
                        DrawerTile(
                          onTap: ()=> aboutDialog(context),
                          icon: Icons.info_outline_rounded,
                          title: 'عن التطبيق',
                        ),
                      ],
                    ),
                  ],
                );
                }else {
                  return SizedBox();
                }
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: DrawerTile(
              onTap: () {
                Navigator.pop(context);
                fb.signOut();
              },
              title: 'تسجيل الخروج',
              icon: AntDesign.logout,
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final Function? onTap ;
  final IconData? icon ;
  final String? title ;
  final Widget? leading ;

  const DrawerTile({ this.onTap, this.icon, this.title, this.leading});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      trailing: Icon(icon,color: Colors.white),
      title: Text(title!,style: TextStyle(color: Colors.white),textDirection: TextDirection.rtl),
      onTap: onTap as void Function()?,
      leading: leading,
    );
  }
}
