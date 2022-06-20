import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/components/photoViwer.dart';
import 'package:m3yen/components/reused.dart';
import 'package:m3yen/screens/drawer/drawer_body.dart';
import 'package:m3yen/screens/popups/city_Picker.dart';
import 'package:m3yen/screens/popups/custom_drop.dart';
import 'package:m3yen/screens/popups/pick_jop.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool? newStatus;
  String _skill = '';
  TextEditingController _ctrl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final User user = Provider.of<User>(context);
    final FB fb = Provider.of<FB>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(48, 129, 210, 1.0),
        endDrawer: Drawer(
            child: DrawerBody(
          root: 'profile',
        )),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Nisebuschgardens'),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(
                AntDesign.menufold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          decoration: gradientBack(),
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: StreamBuilder<LocalUser>(
                    stream: FB(uID: user.uid).userInformation,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final currentName = snapshot.data!.name;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 80, 10, 10),
                              margin: EdgeInsets.only(top: snapshot.data!.completed! ? 0 : 60, bottom: 15),
                              child: Column(
                                children: [
                                  FadeScaleAnimation(
                                    duration: 500,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(0, 70, 0, 10),
                                      width: width - 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          MyTile(
                                            title: '${snapshot.data!.name}',
                                            pre: false,
                                            iconData: AntDesign.user,
                                            enabled: true,
                                            onChanged: (name) {
                                              if (name != null && name != '') {
                                                fb.updateMyName(name: name);
                                              } else if (name == null || name == '') {
                                                fb.updateMyName(name: currentName);
                                              }
                                            },
                                          ),
                                          MyTile(
                                            pre: false,
                                            title: '${snapshot.data!.phone}',
                                            iconData: AntDesign.phone,
                                            enabled: false,
                                          ),
                                          CustomDrop(
                                            child: CityPicker(customPickerFor: CustomPickerFor.updateAcc),
                                            icon: Icons.location_on_outlined,
                                            title: snapshot.data!.cityFromFB!.arName,
                                            tag: 'pickCity',
                                            width: width,
                                            color: kPrimaryLightColor.withOpacity(.5),
                                          ),
                                          CustomDrop(
                                            child: JopPicker(customPickerFor: CustomPickerFor.updateAcc),
                                            icon: Icons.work_outline_rounded,
                                            title: snapshot.data!.jobFromFB!.arName,
                                            tag: 'pickJop',
                                            width: width,
                                            color: kPrimaryLightColor.withOpacity(.5),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: kPrimaryLightColor.withOpacity(.5),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Row(
                                              textDirection: TextDirection.rtl,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.history_toggle_off_rounded,
                                                  color: Colors.green,
                                                  size: 22,
                                                ),
                                                Text(
                                                  newStatus ?? snapshot.data!.free! ? 'متفرغ' : 'يعمل',
                                                  style: TextStyle(color: Color.fromRGBO(39, 105, 171, 1), fontSize: 16),
                                                ),
                                                Switch(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      newStatus = value;
                                                      fb.updateMyState(free: newStatus);
                                                    });
                                                  },
                                                  value: newStatus ?? snapshot.data!.free!,
                                                  activeColor: Colors.green,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  FadeScaleAnimation(
                                    duration: 500,
                                    child: Container(
                                      width: width - 20,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Wrap(
                                            textDirection: TextDirection.rtl,
                                            children: snapshot.data!.skills!.map((skill) {
                                              return GestureDetector(
                                                onLongPress: () {
                                                  fb.removeASkill(skill: skill);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 8,
                                                  ),
                                                  margin: EdgeInsets.only(
                                                    left: 10,
                                                    bottom: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryLightColor,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    skill,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(39, 105, 171, 1),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          MyTile(
                                            pre: true,
                                            title: 'اضف بعض المهارات',
                                            iconData: AntDesign.edit,
                                            enabled: true,
                                            ctrl: _ctrl,
                                            onPrefix: () {
                                              if (_skill.length > 2) {
                                                fb.updateMySkills(skill: _skill);
                                                _ctrl.clear();
                                                _skill = '';
                                              }
                                            },
                                            onChanged: (skill) {
                                              _skill = skill;
                                            },
                                          ),
                                          snapshot.data!.skills!.length > 0
                                              ? Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    'اضغط مطولاً للحذف',
                                                    textScaleFactor: .9,
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  FadeScaleAnimation(
                                    duration: 500,
                                    child: Container(
                                      width: width - 20,
                                      padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              'الوسائط',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color.fromRGBO(39, 105, 171, 1),
                                              ),
                                            ),
                                            subtitle: Text(
                                              '(بطاقة الهوية و شهادات الخبرة)',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color.fromRGBO(39, 105, 171, 1),
                                              ),
                                            ),
                                            leading: IconButton(
                                              icon: Icon(
                                                AntDesign.addfile,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                fb.uploadImages(context: context, profilePic: false);
                                              },
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          Divider(thickness: 1.5, height: 1.5),
                                          SizedBox(height: 15),
                                          Wrap(
                                            textDirection: TextDirection.rtl,
                                            children: snapshot.data!.certifications!.map((url) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PhotoViewer(
                                                                imageUrl: url,
                                                              )));
                                                },
                                                onLongPress: () {
                                                  fb.removeCertification(url: url);
                                                },
                                                child: Container(
                                                  width: width / 3,
                                                  height: width / 2,
                                                  child: Hero(
                                                    tag: url,
                                                    child: CertPic(
                                                      url: url,
                                                      radius: 100,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          snapshot.data!.certifications!.length > 0
                                              ? Padding(
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    'اضغط مطولاً للحذف',
                                                    textScaleFactor: .9,
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: snapshot.data!.completed! ? 0 : 60,
                              child: FadeScaleAnimation(
                                duration: 450,
                                child: GestureDetector(
                                  onTap: () {
                                    fb.uploadImages(context: context, profilePic: true);
                                  },
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 140,
                                        child: snapshot.data!.picUrl == ''
                                            ? Image.asset(
                                                'assets/images/profile.png',
                                                width: 120,
                                                fit: BoxFit.fitWidth,
                                              )
                                            : CertPic(
                                                url: snapshot.data!.picUrl,
                                                radius: 120,
                                                borderRad: 60,
                                              ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 5,
                                        child: Icon(
                                          Icons.add_a_photo_outlined,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      snapshot.data!.completed!
                                          ? Positioned(
                                              bottom: 10,
                                              right: 5,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.blue,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else
                        return Center(child: CircularProgressIndicator());
                    }),
              ),
              Positioned(
                top: 2,
                child: IgnorePointer(child: completeURProfile(uid: user.uid)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function? onChanged, onPrefix;
  final bool enabled, pre;
  final TextEditingController? ctrl;

  const MyTile({required this.title, required this.iconData, this.onChanged, required this.enabled, required this.pre, this.onPrefix, this.ctrl});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: kPrimaryLightColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          onChanged: onChanged as void Function(String)?,
          enabled: enabled,
          controller: ctrl,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.bottom,
          style: TextStyle(color: Color.fromRGBO(39, 105, 171, 1)),
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 5, top: 0, bottom: 0),
              child: Icon(
                iconData,
                color: Colors.green,
                size: 20,
              ),
            ),
            hintText: title,
            prefixIcon: pre
                ? FloatingActionButton(
                    mini: true,
                    onPressed: onPrefix as void Function()?,
                    child: Icon(Icons.check, color: Colors.green),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  )
                : SizedBox(width: 40, height: 20),
            hintStyle: TextStyle(color: Color.fromRGBO(39, 105, 171, 1)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
