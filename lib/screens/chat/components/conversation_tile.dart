import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m3yen/service/firebase.dart';

import '../homChat.dart';

class ConversationTile extends StatelessWidget {
  final String? uid ;

  const ConversationTile({this.uid}) ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUser>(
      stream: FB(uID: uid ).userInformation,
      builder: (context, user) {
        if(user.hasData){
          return Padding(
            padding:  EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> Chat(
                      localUser: user.data
                    ),
                  ));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  maxRadius: 25,
                  backgroundImage: (user.data!.picUrl == '' ? AssetImage('assets/images/profile.png',) :CachedNetworkImageProvider(user.data!.picUrl!)) as ImageProvider<Object>? ,
                ),
                title: Text( user.data!.name!,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: StreamBuilder<int>(
                  stream: FB(receiverUID:uid ).numOFUnReadMSG,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data! > 0)
                      return Container(
                        padding: EdgeInsets.fromLTRB(8 , 8, 8, 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellowAccent,
                        ),
                        child: Text( '${snapshot.data}',
                          style: TextStyle(color: Colors.black , fontSize: 12 , fontWeight: FontWeight.bold ),
                        ),
                      );
                      else return SizedBox();
                    }else return SizedBox();

                  }
                )
            ),
          );
        }else {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              maxRadius: 25,
              backgroundImage: AssetImage('assets/images/profile.png',),
            ),
            title: Text( 'name',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
