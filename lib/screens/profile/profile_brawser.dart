import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/components/photoViwer.dart';
import 'package:m3yen/components/reused.dart';
import 'package:m3yen/screens/chat/homChat.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../constants.dart';


class ProfileBrawser extends StatefulWidget {

  final String? userUID ;

  ProfileBrawser({required this.userUID}) ;


  @override
  _ProfileBrawserState createState() => _ProfileBrawserState();
}

class _ProfileBrawserState extends State<ProfileBrawser> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(48, 129, 210, 1.0),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(48, 129, 210, 1.0),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_forward),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Icon(null),
          title: Text('Profile',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 34, fontFamily: 'Nisebuschgardens'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          decoration: gradientBack(),
          width: width,
          height: height,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: .8 , end: 1.0),
            duration: Duration(milliseconds: 350),
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
            child: StreamBuilder<LocalUser>(
              stream: FB(uID: widget.userUID).userInformation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 80, 10, 10),
                              margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 80),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyTile(
                                    title: '${snapshot.data!.name}',
                                    iconData: AntDesign.user,
                                  ),
                                  GestureDetector(
                                    onTap: () => launchUrlString('tel:${snapshot.data!.phone}'),
                                    child: MyTile(
                                      title: '${snapshot.data!.phone}',
                                      iconData: AntDesign.phone,
                                    ),
                                  ),
                                  MyTile(
                                    title: '${snapshot.data!.cityFromFB!.arName}',
                                    iconData: Icons.location_on_outlined,
                                  ),
                                  MyTile(
                                    title: '${snapshot.data!.jobFromFB!.arName}',
                                    iconData: Icons.work_outline_rounded,
                                  ),
                                  MyTile(
                                    title: snapshot.data!.free! ? 'متفرغ' : 'يعمل',
                                    iconData: Icons.history_toggle_off_rounded,
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: kPrimaryLightColor.withOpacity(.5),
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text('المهارات',
                                              textAlign: TextAlign.right,
                                              textScaleFactor: 1.2,
                                              style: TextStyle(color: Color.fromRGBO(39, 105, 171, 1)),),
                                          ),
                                        ),
                                        Divider(thickness: .8),
                                        Wrap(
                                          textDirection: TextDirection.rtl,
                                          children: snapshot.data!.skills!.map((skill) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8,),
                                              margin: EdgeInsets.only(left: 10, bottom: 5,),
                                              decoration: BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(skill,
                                                style: TextStyle(color: Color.fromRGBO(39, 105, 171, 1),),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: kPrimaryLightColor.withOpacity(.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text('الهوية و شهادات الخبرة',
                                              textAlign: TextAlign.right,
                                              textScaleFactor: 1.2,
                                              style: TextStyle(color: Color.fromRGBO(39, 105, 171, 1)),),
                                          ),
                                        ),
                                        Divider(thickness: .8),
                                        Wrap(
                                          textDirection: TextDirection.rtl,
                                          children: snapshot.data!.certifications!.map((url) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: RawMaterialButton(
                                                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> PhotoViewer(imageUrl: url,)));},
                                                child: Container(
                                                  width: width*.4-10,
                                                  height: width*.35,
                                                  child: Hero(
                                                    tag: url,
                                                    child: CertPic(url: url , radius: 100,),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              top: 80,
                              right: 10,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: RawMaterialButton(
                                  child: Icon(AntDesign.message1, color: Colors.green,size: 20),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> Chat(localUser: snapshot.data,))),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 80,
                              left: 10,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: RawMaterialButton(
                                  child: Image.asset('assets/images/whats.png',height: 25,),
                                  onPressed: () => launchUrlString('https://api.whatsapp.com/send?phone=${snapshot.data!.cCode}${snapshot.data!.phone}'),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width:  140,
                                    height: 140,
                                    child: snapshot.data!.picUrl == '' ?
                                    Image.asset('assets/images/profile.png', width: 120, fit: BoxFit.fitWidth,) :
                                    CertPic(url: snapshot.data!.picUrl,radius: 120,borderRad: 100,),
                                  ),
                                  snapshot.data!.completed! ?
                                  Positioned(
                                    bottom: 10,
                                    right: 5,
                                    child: Icon(Icons.check_circle , color: Colors.blue,),
                                  ): SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: StreamBuilder<String?>(
                          stream: FB().ifAdmin,
                          builder: (context, accType) {
                            if(accType.hasData){
                              if(accType.data == 'admin')
                              return RawMaterialButton(
                                fillColor: Colors.yellowAccent,
                                shape: StadiumBorder(),
                                onPressed: () {
                                  FB().acceptWorker(uid: snapshot.data!.uid,completed: !snapshot.data!.completed! );
                                },
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                  child: Row(
                                    children: [
                                      Icon( snapshot.data!.completed! ? Icons.clear : Icons.check_circle , color: Colors.blueAccent,),
                                      SizedBox(width: 15),
                                      Text( snapshot.data!.completed! ? 'رفض' : 'قبول',
                                        style: TextStyle( fontSize: 18 , fontWeight: FontWeight.bold ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              else return SizedBox();
                            }
                            else return SizedBox();
                          }
                        ),
                      ),
                    ],
                  );
                }
                else
                  return Center(child: CircularProgressIndicator());
              }),
          ),
        ),
      ),
    );
  }
}


class MyTile extends StatelessWidget {
  final String title ;
  final IconData iconData ;

  const MyTile({required this.title,required this.iconData,});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: kPrimaryLightColor.withOpacity(.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(null, size: 20,),
          Text(title,style:TextStyle(color: Color.fromRGBO(39, 105, 171, 1)),textScaleFactor: 1.05,),
          Icon(iconData, color: Colors.green , size: 20,),
        ],
      ),
    );
  }
}

