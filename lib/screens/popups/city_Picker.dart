import 'package:flutter/material.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'hero_dialog.dart';



class CityPicker extends StatelessWidget {

  final CustomPickerFor? customPickerFor;
  final Function? loadMoreCallBack ;

  CityPicker({this.loadMoreCallBack, this.customPickerFor});

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size ;
    final FB fb = Provider.of<FB>(context) ;

    return Center(
      child: Hero(
        tag: 'pickCity',
        createRectTween: (begin , end){
          return HeroTween(begin: begin, end: end);
        },
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    width: size.width-20,
                    height: 50,
                    padding: EdgeInsets.only(left: 20,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.location_on_outlined , color: kPrimaryColor),
                        Text('اختر المدينة',style: TextStyle(color: kPrimaryColor ),),
                        IconButton(
                          icon: Icon(Icons.close,color: kPrimaryColor),
                          onPressed:() {
                          Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                SizedBox(
                  width: size.width-20,
                  height: size.height*.5,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: FutureBuilder<List<CityFromFB>>(
                      future: FB().getCities(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData)
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RawMaterialButton(
                              onPressed: () {
                                if(customPickerFor == CustomPickerFor.updateAcc){
                                  fb.updateMyCity( cityFromFB: snapshot.data![index]);
                                }else if(customPickerFor == CustomPickerFor.signUp){
                                  fb.changeSelectedCity(snapshot.data![index].arName);
                                  fb.changeCity(snapshot.data![index]);
                                }
                                else if(customPickerFor == CustomPickerFor.filterRes) {
                                  fb.changeSelectedCity(snapshot.data![index].arName);
                                  loadMoreCallBack!();
                                }
                                Navigator.pop(context);
                              },
                              child: Text("${snapshot.data![index].arName}",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kPrimaryColor, fontSize: 18),
                              ),
                            );
                          },
                        );
                        else return Center(child: CircularProgressIndicator());
                      }
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

