//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
import 'package:sound_of_ai/home.dart';
import 'package:sound_of_ai/phone.dart';
import 'package:sound_of_ai/otp.dart';
import 'package:sound_of_ai/loginpage.dart';
import 'package:sound_of_ai/reg.dart';
import 'package:sound_of_ai/home.dart';
//
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   return GetMaterialApp(
//
//     initialRoute: 'login',
//     debugShowCheckedModeBanner: false,
//     routes: {
//       'phone': (context) => MyPhone(),
//       'verify': (context) => MyOtp(),
//       'home':(context)=>HomePage(),
//       'login':(context)=>LoginPage(),
//       'register':(context)=>SignUpPage(),
//     },
//   ));
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sound_of_ai/auth_controller.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value)=>Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      initialRoute: 'login',
    routes: {
      'phone': (context) => MyPhone(),
      'verify': (context) => MyOtp(),
      'home':(context)=>HomePage(),
      'login':(context)=>LoginPage(),
      'register':(context)=>SignUpPage(),
    },
  );

  }
}

