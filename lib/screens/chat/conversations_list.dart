import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:m3yen/screens/chat/components/conversation_tile.dart';
import '../../constants.dart';

class ConversationsList extends StatefulWidget {
  @override
  _ConversationsListState createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> {

  @override
  Widget build(BuildContext context) {

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
            title: Text('المحادثات',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18,),
            ),
          ),
          body: Container(
            decoration: gradientBack(),
            child: StreamBuilder<QuerySnapshot> (
              stream: FB().conversationsListStream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  if(snapshot.data!.docs.length > 0 ){
                    return ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        final List users = snapshot.data!.docs[index].get('users');
                        return ConversationTile(uid: users.first == FB().auth.currentUser!.uid ? users.last : users.first,);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(height: 1, thickness: 1, color: Colors.black12),
                        );
                      },
                    );
                  }else{
                    return Center(
                      child: Text('ليس لديك محادثات حتي الان',style: TextStyle(color: Colors.white),),
                    );
                  }
                }else return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}



