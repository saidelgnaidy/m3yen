import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m3yen/constants.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';
class Chat extends StatefulWidget {

  final LocalUser? localUser  ;
   Chat({required this.localUser,});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  TextEditingController textCtrl = TextEditingController() ;
  double rad = 20 ;


  ChatMessage mapMessages({required QueryDocumentSnapshot doc , String? myUID}){
    return ChatMessage(
      messageContent: doc.get('text'),
      isMe:  doc.get('sender') == FB().auth.currentUser!.uid ? false :  true,
    );
  }
  @override
  void initState() {
    super.initState();
    FB().markAsSeen(receiverUid: widget.localUser!.uid!);

  }


  @override
  Widget build(BuildContext context) {
    final FB fb = Provider.of<FB>(context);
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.blue,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: .5,
            leading: Icon(null),
            flexibleSpace: Padding(
              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top + 5,   10, 0),
              child: RawMaterialButton(
                onPressed: () => Navigator.pop(context) ,
                shape: StadiumBorder(),
                child: StreamBuilder<LocalUser>(
                  stream: FB(uID: widget.localUser!.uid).userInformation,
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white,size: 18,),
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          maxRadius: 22,
                          backgroundImage: (snapshot.hasData && widget.localUser!.picUrl != ''
                              ? CachedNetworkImageProvider(widget.localUser!.picUrl!)
                              : AssetImage('assets/images/profile.png',)) as ImageProvider<Object>?,
                        ),
                        SizedBox(width: 10),
                        Text( snapshot.hasData ? snapshot.data!.name! : 'Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18,),
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
          body: Container(
            decoration: gradientBack(),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot> (
                  stream: FB(receiverUID: widget.localUser!.uid).chatStream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return Container(
                              padding: EdgeInsets.only(left: 14,right: 14,top: 3,bottom:3 ),
                              child: Align(
                                alignment: (mapMessages(doc: snapshot.data!.docs[index]).isMe ?Alignment.topLeft:Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: shadow,
                                    borderRadius: BorderRadius.only(
                                      topLeft: mapMessages(doc: snapshot.data!.docs[index]).isMe   ? Radius.circular(0) : Radius.circular(rad),
                                      topRight: Radius.circular(rad),
                                      bottomRight: mapMessages(doc: snapshot.data!.docs[index]).isMe   ? Radius.circular(rad) : Radius.circular(0),
                                      bottomLeft:  Radius.circular(rad),
                                    ),
                                    color: (mapMessages(doc: snapshot.data!.docs[index]).isMe  ? Colors.lightBlue:Colors.white),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                  child: Text(mapMessages(doc: snapshot.data!.docs[index]).messageContent!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: mapMessages(doc: snapshot.data!.docs[index]).isMe  ? Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }else return Expanded(child: Center(child: CircularProgressIndicator()));
                  }
                ),
                SizedBox(height: 5),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black12,
                ),
                Container(
                  width: size.width,
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: TextField(
                    controller: textCtrl,
                    maxLines: 20,
                    minLines: 1,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "اكتب هنا....",
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FloatingActionButton(
                          onPressed: () {
                            if(textCtrl.text != ''){
                              fb.sendMessage(text: textCtrl.text , receiver: widget.localUser!.uid! );
                              textCtrl.clear();
                            }
                          },
                          backgroundColor: Colors.white,
                          child: Icon(Icons.send , color: Colors.blue,size: 18,),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage{
  String? messageContent;
  bool isMe;
  ChatMessage({required this.messageContent, required this.isMe});
}

