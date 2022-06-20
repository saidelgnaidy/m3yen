import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:m3yen/screens/Welcome/welcome_screen.dart';
import 'package:m3yen/screens/main_nav/nav_screen.dart';
import 'package:m3yen/service/firebase.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamProvider.value(
        value: FB().userState,
        initialData: null,
        child: ChangeNotifierProvider<FB>(
            create: (BuildContext context) => FB(),
            builder: (context, snapshot) {
            return MaterialApp(
              title: 'M3yen',
              debugShowCheckedModeBanner: false,
              supportedLocales: [Locale('ar' , ''), Locale('en' , ''),],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              localeResolutionCallback: (currentLocale , supportedLocales){
                return  supportedLocales.last;
              },

              theme: ThemeData(
                fontFamily: 'TajawalRegular',
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                appBarTheme: AppBarTheme(color: Color(0xff2c3d69),
                ),
              ),
              home:  Wrapper(),
            );
          }
        ),
      ),
    );
  }
}



class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<User?>(context);

    if (userState != null) {
      return NavigationScreen();
    } else {
      return WelcomeScreen();
    }
  }
}

