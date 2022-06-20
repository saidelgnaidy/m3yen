import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m3yen/components/reused.dart';
import 'package:m3yen/constants.dart';
import 'package:path/path.dart';

class LocalUser {
  final  String? name   , phone , accType ,picUrl , uid , cCode ;
  final JobFromFB? jobFromFB;
  final CityFromFB? cityFromFB;
  final bool? completed  , free;
  final List? skills , certifications ;
  final DocumentSnapshot? doc ;
  LocalUser({this.doc, this.cCode, this.uid, this.certifications, this.skills, this.free, this.picUrl,  this.jobFromFB, this.cityFromFB, this.name, this.phone, this.accType ,this.completed,});
}

class CityFromFB {
  final String? arName , enName ;
  CityFromFB({this.arName, this.enName});
}

class JobFromFB {
  final String? arName , enName ;
  JobFromFB({this.arName, this.enName});
}
class ConversationListItem {
  final String? roomID , userUID , name , picUrl;
  final bool? seen ;
  ConversationListItem({this.seen, this.name, this.picUrl, this.roomID, this.userUID});
}

class MSG {
  final String? text , sender , receiver , time ;
  MSG({this.text, this.sender, this.receiver, this.time});
}

class FB  extends ChangeNotifier{

  final String? uID  , receiverUID;
  final FirebaseAuth auth                 = FirebaseAuth.instance ;
  final CollectionReference users         = FirebaseFirestore.instance.collection('Users');
  final CollectionReference cities        = FirebaseFirestore.instance.collection('Cities');
  final CollectionReference jobs          = FirebaseFirestore.instance.collection('jobs');
  final CollectionReference phones        = FirebaseFirestore.instance.collection('Phones');
  final CollectionReference chats         = FirebaseFirestore.instance.collection('Chats');

  FB({this.receiverUID ,this.uID});

  CityFromFB? pickedCity ;
  JobFromFB? pickedJop ;
  bool?  _isLoading = false , invalidToken = false  , fbErrorBool = false , completed , noMoreResults = false ,showLoadingIndicator = false;
  bool? get loadingState => _isLoading   ;
  DocumentSnapshot? lastDoc ;

  String? get errorMSGFromFB => fbErrorMSG ;
  String? selectedJob  , selectedCity , _token  , fbErrorMSG = '' , lastCity  , lastJob ;
  int queryLimit = 5 ;
  List<CityFromFB> citiesFromFB = [] ;
  List<JobFromFB> jobFromFBList = [] ;
  List<LocalUser> usersQueryList = [];

  completedFilter({int? id }){
    if(id == 1){
      completed = true ;
    }else if(id == 2){
      completed = false ;
    }else{
      completed = null ;
    }
    notifyListeners() ;
  }
  changeSelectedJop( String? jop )  {
    selectedJob = jop ;
    notifyListeners();
  }
  changeSelectedCity( String? city )  {
    selectedCity = city ;
    notifyListeners();
  }
  changeCity( CityFromFB city )  {
    pickedCity = city ;
    notifyListeners();
  }
  changeJop( JobFromFB jop )  {
    pickedJop = jop ;
    notifyListeners();
  }

  updateMySkills({String? skill}) async {
    await users.doc(auth.currentUser!.uid ).update({
      'skills': FieldValue.arrayUnion([skill]),
    });
  }
  removeASkill({String? skill}) async {
    await users.doc(auth.currentUser!.uid ).update({
      'skills': FieldValue.arrayRemove([skill]),
    });
  }
  removeCertification({String? url}) async {
    await users.doc(auth.currentUser!.uid ).update({
      'certifications': FieldValue.arrayRemove([url]),
    });
  }
  updateMyState({bool? free  }) async {
    await users.doc(auth.currentUser!.uid ).update({
      'free':free ,
    });
  }
  updateMyCity({ required CityFromFB cityFromFB }) async {
    await users.doc(auth.currentUser!.uid ).update({
      'CityAR' :  cityFromFB.arName ,
      'CityEN' :  cityFromFB.enName,
    });
  }
  updateMyJop({ required JobFromFB jobFromFB }) async {
    await users.doc(auth.currentUser!.uid ).update({
      'JobAR'  :  jobFromFB.arName  ,
      'JobEN'  :  jobFromFB.enName ,
    });
  }
  updateMyName({ String? name }) async {
    await users.doc(auth.currentUser!.uid ).update({
      'Name'   : name,
    });
  }
  acceptWorker({String? uid , bool? completed}) async {
    await users.doc(uid ).update({
      'completed'   : completed,
    });
  }
  setErrorsToFalse(){
    fbErrorBool = false ;
    _isLoading = false ;
    fbErrorMSG = '' ;
    notifyListeners() ;
  }
  setUserInformation({ String? phone , String? cCode , String? name ,String? accType , String? uid}) async {
    await phones.doc(phone).set({
      'phone':phone,
      'cCode':cCode,
    });
    await users.doc(uid).set({
      'Name'   : name,
      'UID'    : uid,
      'Phone'  : phone ?? '',
      'AccType': accType,
      'CityAR' :  pickedCity!.arName ,
      'CityEN' :  pickedCity!.enName,
      'JobAR'  : accType == AccTypeEnum.worker.toString() ?  pickedJop!.arName   : '',
      'JobEN'  : accType == AccTypeEnum.worker.toString() ?  pickedJop!.enName   : '',
      'completed' : accType == AccTypeEnum.worker.toString() ?  false : true  ,
      'picURL' :'',
      'free': true ,
      'cCode':cCode,
      'certifications': [],
      'skills':[],

    });
  }

  Future<List<CityFromFB>>  getCities() async {
    final cityList =  await cities.orderBy('ArName').get() ;
    cityList.docs.forEach((doc) {
      citiesFromFB.add(CityFromFB(enName:doc.get('EnName') , arName: doc.get('ArName') ),);
    });
    return citiesFromFB ;
  }

  Future<List<JobFromFB>>  getJobs() async {
    final jopList =  await jobs.orderBy('ArJob').get() ;
    jopList.docs.forEach((snap) {
      jobFromFBList.add(JobFromFB(enName:snap.get('EnJob') , arName: snap.get('ArJob') ),);
    });
    return jobFromFBList ;
  }

  Future<String>  getMyCountry() {
    return users.doc(auth.currentUser!.uid).get().then((snap) {
      return  snap.get('CityAR') ;
    });
  }

  LocalUser mappingADoc(DocumentSnapshot snap){
    return LocalUser(
      doc: snap,
      name: snap.get('Name'),
      phone: snap.get('Phone'),
      accType: snap.get('AccType'),
      cityFromFB: CityFromFB(arName: snap.get('CityAR') , enName: snap.get('CityEN')) ,
      jobFromFB: JobFromFB(enName: snap.get('JobEN') , arName: snap.get('JobAR')),
      completed: snap.get('completed'),
      picUrl: snap.get('picURL'),
      free: snap.get('free'),
      skills: snap.get('skills') ?? [],
      certifications: snap.get('certifications') ?? [],
      uid: snap.get('UID') ?? '',
      cCode: snap.get('cCode') ?? '',
    );
  }

  Stream<LocalUser> get userInformation  {
    return users.doc(uID).snapshots().map((snap) {
      return mappingADoc(snap);
    });
  }

  Future<List<LocalUser>> usersQuery({String? jop, String?  city , bool? completedFilter , required bool loadMoreCalled}) async {

    var  baseQuery = users
        .where('AccType', isEqualTo: 'AccTypeEnum.worker')
        .where( 'JobAR',isEqualTo: jop )
        .where('CityAR',isEqualTo: city)
        .where('completed' ,isEqualTo: completedFilter);
      try{
        var result ;
        if(loadMoreCalled){
          noMoreResults = false ;
          showLoadingIndicator = true ;
          print('load More ... !');
          result = await  baseQuery.startAfterDocument(this.lastDoc!).limit(6).get() ;
          showLoadingIndicator = false ;
        }else{
          result = await baseQuery.limit(6).get();
          usersQueryList = [] ;
        }
        this.lastDoc =  result.docs.last ;
        result.docs.forEach((snap) {
          usersQueryList.add(
            mappingADoc(snap),
          );
        });
      }catch(e){
        noMoreResults = true ;
        showLoadingIndicator = false ;
        print('No More ... !');
      }
      return usersQueryList ;
  }

  Future uploadImages({BuildContext? context , required bool profilePic }) async {
    PickedFile? _image;
    double uploadProgress ;

    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile? img = await ImagePicker.platform.pickImage(source: ImageSource.gallery , maxWidth: profilePic ? 360 : null , imageQuality: profilePic ? 100 : 75);
    _image = img ;
    if (_image != null) {
      print(_image.path);
      Reference  _storage = FirebaseStorage.instance.ref().child(basename(_image.path));
      UploadTask uploadTask =  _storage.putFile(File(_image.path))..snapshotEvents.listen((event) {
        uploadProgress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        print(uploadProgress);
      }).onError((error) {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            shape: StadiumBorder(),
            elevation: 5,
            content: Container(
              height: 30,
              child: Center(
                child: Text('خطأ في الاتصال',
                  textScaleFactor: 1.1,
                  style: TextStyle(color: Colors.green,),
                ),
              ),
            ),
          ),
        );
      });
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          shape: StadiumBorder(),
          elevation: 5,
          content: Container(
            height: 30,
            child: Center(
              child: Text('...يتم رفع الملف',
                textScaleFactor: 1.1,
                style: TextStyle(color: Colors.white,),
              ),
            ),
          ),
        ),
      );
      var taskCompleted = await uploadTask ;
      taskCompleted.ref.getDownloadURL().then((downURL) async {
        if(!profilePic){
          await users.doc(auth.currentUser!.uid ).update({
            'certifications': FieldValue.arrayUnion([downURL]),
          });
        }else{
          await users.doc(auth.currentUser!.uid ).update({
            'picURL': downURL,
          });
        }
      });
    }
    else{
      print('******************* no image selected *******************');
    }
  }

  Stream<String?> get ifAdmin {
    return users.doc(auth.currentUser!.uid).snapshots().map((snap) {
      return  snap.get('AccType') ;
    });
  }

  Future<bool> checkIfAPhoneIsRegistered({phone}) async {
    final result =  await phones.where('phone' , isEqualTo:  phone).get();
    if(result.docs.length == 0) return false ;
    else return true ;
  }

  Future phoneAuth ({required String? phone , String? cCode ,  BuildContext? context , String? name ,String? accType ,required bool login}) async {
    _isLoading = true ;
    fbErrorBool = false ;
    notifyListeners();
    auth.verifyPhoneNumber(
      phoneNumber: '$cCode$phone',
      timeout: Duration(seconds: 5),
      verificationCompleted: (AuthCredential authCred ) async {
        UserCredential result = await auth.signInWithCredential(authCred);
        print('******* ${result.user!.phoneNumber} From verificationCompleted ********') ;
        if(!login){
          setUserInformation(name: name,phone: phone,cCode: cCode, uid: result.user!.uid , accType: accType);
        }
        if (result.user != null){
          Navigator.pop(context!);
        }
        _isLoading = false ;
        notifyListeners() ;
      },
      verificationFailed: (FirebaseAuthException  authException ){
        fbErrorBool = true ;
        if (authException.code == 'network-request-failed' ){
          fbErrorMSG = 'تأكد من اتصالك';
        }
        else if (authException.code == 'invalidCredential'){
          fbErrorMSG = 'تأكد من اتصالك';
        }
        else if (authException.code == 'invalid-phone-number'){
          fbErrorMSG = 'رقم هاتف غير صحيح';
        }else {
          fbErrorMSG = authException.code.toString();
        }
        _isLoading = false ;
        notifyListeners();
        print(authException.code);
      },
      codeSent: (String verificationId ,[int? forceResendToken] ){
        _isLoading = false ;
        invalidToken = false;
        fbErrorBool = false ;
        selectedJob = null ;
        selectedCity = null ;
        notifyListeners();
        showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (context){
            return StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  title: Center(child: Text('ادخل رمز التحقق' ,style: TextStyle(color: Color.fromRGBO(39, 105, 171, 1) , fontSize: 20),)),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RoundedInputField(
                            hintText: "رمز التحقق",
                            type: TextInputType.phone,
                            icon: null,
                            onChanged: (value) {
                              _token  = value ;
                            },
                          ),
                          invalidToken == true ? Text('الرمز غير صحيح') : SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: RoundedButton(
                                  press: (){
                                    invalidToken = false ;
                                    Navigator.pop(context);
                                  },
                                  text: 'الغاء',
                                  color: Colors.blue,
                                ),
                              ),
                              Container(
                                width: 100,
                                child: RoundedButton(
                                  press: () async {
                                    try{
                                      AuthCredential authCred = PhoneAuthProvider.credential(verificationId:verificationId , smsCode: _token!);
                                      UserCredential result = await auth.signInWithCredential(authCred);
                                      if (result.user != null ) {
                                        print('******* From onCodeSent ********') ;
                                        if(!login){
                                          setUserInformation(name: name,phone: phone,cCode: cCode, uid: result.user!.uid , accType: accType);
                                        }
                                        if (result.user != null){
                                          Navigator.pop(context);
                                        }
                                        _isLoading = false ;
                                        notifyListeners() ;
                                      }
                                    }
                                    catch (e){
                                      print('$e **** wrong code ');
                                      setState((){
                                        invalidToken = true;
                                      });
                                    }
                                  },
                                  text: 'تحقق',
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          _isLoading == true ? CircularProgressIndicator() :SizedBox(),
                        ],
                      );
                    },
                  ),
                ) ;
              },

            );
          },
        );
      },
      codeAutoRetrievalTimeout: (codeRetrieval){
        print(' ********* $codeRetrieval ***** ');
      },
    );
  }

  Future signOut() async {
    await auth.signOut() ;
  }

  Stream<User?> get userState {
    return auth.authStateChanges() ;
  }


  ///chat backend

  Future sendMessage({String? text  , required String receiver  }) async  {
    final time = Timestamp.now().microsecondsSinceEpoch ;

    chats.doc(calcRoomId(receiver)).set({
      'roomId'     : calcRoomId(receiver) ,
      'users'      :FieldValue.arrayUnion([auth.currentUser!.uid , receiver]) ,
      'timeStamp'  :time,
      'lastSeen': false ,
      'lastSender': auth.currentUser!.uid
    });
    await chats.doc(calcRoomId(receiver)).collection('messages').doc().set({
      'text'       :text ,
      'sender'      : auth.currentUser!.uid,
      'timeStamp'  :time,
      'seen' : false ,
    });
  }

  Stream<QuerySnapshot>  get chatStream  {
    return chats.doc(calcRoomId(receiverUID!)).collection('messages').orderBy('timeStamp',descending: true).snapshots().map((snap) {
      return snap ;
    });
  }

  Stream<QuerySnapshot> get conversationsListStream  {
    return chats.where('users' , arrayContains: auth.currentUser!.uid).orderBy('timeStamp',descending: true).snapshots() ;
  }

  Stream<QuerySnapshot> get  checkUnSeenMsg {
   return chats.where('users',arrayContains: auth.currentUser!.uid ).where('lastSeen' , isEqualTo:  false).where('lastSender' , isNotEqualTo: auth.currentUser!.uid).snapshots();
  }


  Stream<int> get numOFUnReadMSG  {
    return chats.doc(calcRoomId(receiverUID!)).collection('messages')
        .where('sender',isNotEqualTo: auth.currentUser!.uid )
        .where('seen' , isEqualTo:  false)
        .snapshots().map((snap) {
          return snap.docs.length ;
        }) ;
  }

  markAsSeen({required String receiverUid}) async {
    final doc  = await chats.doc(calcRoomId(receiverUid)).get() ;
    try{
      if(doc.get('lastSeen') == false && doc.get('lastSender') != auth.currentUser!.uid){
        chats.doc(calcRoomId(receiverUid)).update({
          'lastSeen': true,
        });
      }
    }catch(e){
      print(e);
    }

    final result  = await chats.doc(calcRoomId(receiverUid)).collection('messages').where('seen' , isEqualTo:  false).get() ;
    result.docs.forEach((doc) async {
      if(doc.get('sender') != auth.currentUser!.uid){
        await chats.doc(calcRoomId(receiverUid)).collection('messages').doc(doc.id).update({
          'seen' : true ,
        });
      }else return ;
    });
  }

  String calcRoomId(String receiverUid ){
    String roomId = '' ;
    if(auth.currentUser!.uid.substring(0 ,1).codeUnitAt(0) > receiverUid.substring(0,1).codeUnitAt(0)){
      roomId  = '$receiverUid\_${auth.currentUser!.uid}' ;
    }else roomId =  '${auth.currentUser!.uid}\_$receiverUid' ;
    return roomId ;

  }




}
































































// Future<UserCredential> signUP({@required String email ,  @required String password , @required String name , String phone , @required String accType }) async {
//   UserCredential result ;
//   try {
//     _isLoading = true ;
//     notifyListeners() ;
//     await Future.delayed(Duration(seconds: 1  ));
//     result = await auth.createUserWithEmailAndPassword(email: email.replaceAll(' ', '').replaceAll('  ', '').trim(), password: password);
//     if(result.user != null ){
//       print('******* ${result.user.email} Successful ********') ;
//       await users.doc(result.user.uid).set({
//         'Name'   : name,
//         'UID'    : result.user.uid,
//         'Email'  : email,
//         'Phone'  : phone ?? '',
//         'AccType': accType,
//         'CityAR' : accType == AccTypeEnum.worker.toString() ?  pickedCity.arName  : '',
//         'CityEN' : accType == AccTypeEnum.worker.toString() ?  pickedCity.enName  : '',
//         'JobAR'  : accType == AccTypeEnum.worker.toString() ?  pickedJop.arName   : '',
//         'JobEN'  : accType == AccTypeEnum.worker.toString() ?  pickedJop.enName   : '',
//         'completed' : accType == AccTypeEnum.worker.toString() ?  false : true  ,
//         'picURL' :'',
//         'free': true ,
//       });
//       _isLoading = false ;
//       notifyListeners() ;
//     }else{
//       print('******* $result  *******') ;
//       _isLoading = false ;
//       notifyListeners() ;
//     }
//   }catch (e){
//     _isLoading = false ;
//     notifyListeners() ;
//     print('******* $e *******');
//   }
//   notifyListeners();
//   return result ;
// }
// Future<UserCredential> login({@required String email ,@required password }) async {
//   UserCredential result ;
//   try{
//     _isLoading = true ;
//     notifyListeners() ;
//     await Future.delayed(Duration(seconds: 1  ));
//     result = await auth.signInWithEmailAndPassword(email: email.replaceAll(' ', '').replaceAll('  ', '').trim(), password: password);
//     _isLoading = false ;
//     notifyListeners() ;
//   }catch(e){
//     _isLoading = false ;
//     notifyListeners() ;
//   }
//   notifyListeners();
//   return result ;
// }