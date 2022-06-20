import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:m3yen/components/reused.dart';
import 'package:m3yen/screens/chat/conversations_list.dart';
import 'package:m3yen/screens/drawer/drawer_body.dart';
import 'package:m3yen/screens/popups/city_Picker.dart';
import 'package:m3yen/screens/popups/custom_drop.dart';
import 'package:m3yen/screens/main_nav/componant.dart';
import 'package:m3yen/screens/popups/pick_jop.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class NavigationScreen extends StatefulWidget {

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  static List items = [
    RadioItem(id: 2, title: "مراجعة"),
    RadioItem(id: 1, title: "موثق"),
    RadioItem(id: 3, title: "الكل"),
  ];

  ScrollController? _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  RadioItem? selectedItem = items.last;
  bool loadMore = false;

  List<Widget> createRadioListUsers({FB? fb }) {
    List<Widget> widgets = [];
    for (RadioItem item in items as Iterable<RadioItem>) {
      widgets.add(
        Container(
          width: (MediaQuery.of(context).size.width-10)/3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(item.title! ,
                style:  TextStyle(color: selectedItem == item ? Colors.green : Colors.blue ,  ),
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
              ),
              Radio(
                value: item,
                groupValue: selectedItem,
                activeColor: Colors.green,
                onChanged: (dynamic currentItem) {
                  fb!.completedFilter(id: selectedItem!.id);
                  setSelectedItem(currentItem);
                },
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
  setSelectedItem(RadioItem? item) {
    setState(() {
      selectedItem = item;
      loadMore = false ;
    });
  }


  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(() async {
      var currentScroll = _scrollController!.position.pixels ;
      var maxScroll = _scrollController!.position.maxScrollExtent ;
      if(maxScroll - currentScroll == 0 ){
        setState(() {
          loadMore = true ;
        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final FB fb = Provider.of<FB>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Color.fromRGBO(48, 129, 210, 1.0),
      floatingActionButton: StreamBuilder<QuerySnapshot>(
        stream: fb.checkUnSeenMsg,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.data!.docs.length>0){
              return RawMaterialButton(
                shape: StadiumBorder(),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>ConversationsList()));
                },
                fillColor: Colors.yellowAccent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('محادثة جديدة',style: TextStyle(color: Colors.red ),),
                      SizedBox(width: 8),
                      Text('${snapshot.data!.docs.length}',style: TextStyle(color: Colors.red , fontWeight: FontWeight.bold),),
                      SizedBox(width: 8),
                      Icon(Icons.mark_chat_unread_outlined , color: Colors.red,),
                    ],
                  ),
                ),
              );
            }else return SizedBox();
          }
          else return SizedBox() ;
        }
      ),
      endDrawer: Drawer(child: DrawerBody(root: 'home',)),
      body: Container(
        decoration: gradientBack(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Color.fromRGBO(48, 129, 210, 1.0),
              elevation: 0,
              expandedHeight: 142,
              floating: true,
              pinned: true,
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
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomDropMini(
                            child: CityPicker(
                              customPickerFor: CustomPickerFor.filterRes,
                              loadMoreCallBack: (){
                                setState(() {
                                  loadMore = false;
                                });
                              },
                            ),
                            title: fb.selectedCity ??  'كل المدن',
                            tag: 'pickCity',
                          ),
                          CustomDropMini(
                            child: JopPicker(
                              customPickerFor: CustomPickerFor.filterRes,
                              loadMoreCallBack: (){
                                setState(() {
                                  loadMore = false;
                                });
                              },
                            ),
                            title: fb.selectedJob ?? 'كل الوظائف',
                            tag: 'pickJop',
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        height: 40,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white ,
                          boxShadow: shadow,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: createRadioListUsers(fb: fb),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Text(
                "مُعين",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<LocalUser>>(
                future: fb.usersQuery(
                  jop: fb.selectedJob,
                  city: fb.selectedCity ,
                  completedFilter: selectedItem!.id == 1 ? true : selectedItem!.id == 2 ? false : null ,
                  loadMoreCalled: loadMore,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    if (snapshot.data!.length != 0)
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length + 1,
                        padding: EdgeInsets.only(bottom: 20,top: 5),
                        itemBuilder: (BuildContext context, int index) {
                          if(index == snapshot.data!.length)
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: fb.noMoreResults! ?
                                  Text('لا توجد نتائج جديدة' ,
                                    textDirection: TextDirection.rtl,
                                    style:  TextStyle(color: Colors.yellow ),
                                  ) : fb.showLoadingIndicator! ?
                                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)) :
                                  Text('إسحب لعرض المزيد',
                                    textDirection: TextDirection.rtl,
                                  style:  TextStyle(color: Colors.yellow ),
                                ),
                              ),
                            );
                          else return FadeScaleAnimation(child: InfoTile(localUser: snapshot.data![index])) ;
                        },
                      );
                    else return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height*.4),
                        child: Text('لا توجد نتائج' ,
                          textDirection: TextDirection.rtl,
                          style:  TextStyle(color: Colors.yellow ),
                        ),
                      ),
                    );


                  else return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*.4),
                      child: Text('جاري التحميل...' ,
                        textDirection: TextDirection.rtl,
                        style:  TextStyle(color: Colors.yellow ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}



