// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:loginregpage/loginpage.dart';
//
// class WelcomePage extends StatelessWidget {
//   const WelcomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//         double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body:Column(
//         children: [
//           Container(
//               width: w,
//               height:h*0.3,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage(""
//                           "assets/logicon.png"
//                       ),
//                       fit: BoxFit.cover
//                   )
//               ),
//               child: Column(
//                   children:[
//                     SizedBox(height: h*0.16, ),
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: AssetImage(
//                           "assets/profile.png"
//                       ),
//                     )
//                   ]
//               )
//
//           ),
//
//
//           SizedBox(height:w*0.1),
//
//           Container(
//             width:w,
//             margin: const EdgeInsets.only(left:20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Welcome",
//                   style: TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 Text(
//                   "a@a.com",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height:w*0.5),
//
//           RichText(text: TextSpan(
//
//             children: [
//               TextSpan(
//                   text:"LogOut",
//                   style:TextStyle(
//                     color:Colors.grey[500],
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>LoginPage())
//               )
//             ]
//           ),
//                 ),
//               ],
//
//     ),

//     );
//
//
//
//
//
//   }
// }
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';

import 'package:get/get.dart';

import 'package:sound_of_ai/loginpage.dart';
import 'package:get/get.dart';


class Features extends StatefulWidget {
  const Features({Key? key}) : super(key: key);

  @override
  State<Features> createState() => _FeatureState();
}

class _FeatureState extends State<Features> {
  @override

  Future<http.Response> fetchImage() {
    return http.get(Uri.parse('http://16.171.133.237/plot'));

  }
  Future<http.Response> fetchSpect() {
    //return http.get(Uri.parse('http://10.0.2.2:5000/spect'));
    return http.get(Uri.parse('http://16.171.133.237/spect'));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor:Color(0xff36363b),
          title: Text('HeartSound Classifier'),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Get.to(()=>LoginPage());
              },
              child: ElevatedButton(
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: null,
              ),
            ),

          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              height: h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"), // Replace with your background image path
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), // Adjust the opacity here (0.0 - 1.0)
                    BlendMode.dst, // Adjust the blend mode if needed
                  ),
                ),
              ),
            child:Center(
              child: Column(
                  children: [
                    SizedBox(height: h*0.2),
            Container(
              height: MediaQuery.of(context).size.height * 0.18, // Set a fixed height

              child: FutureBuilder<http.Response>(
                future: fetchImage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data!.statusCode == 200) {
                    return Image.memory(snapshot.data!.bodyBytes);
                  } else if (snapshot.hasError) {
                    return Text('Failed to load image');
                  }
                  return CircularProgressIndicator();
                },
              ),
            ) ,

                    SizedBox(height: h*0.05),
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width*0.6,// Set a fixed height
              child: Scaffold(
                body: Center(
                  child: FutureBuilder<http.Response>(
                    future: fetchSpect(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData &&
                          snapshot.data!.statusCode == 200) {
                        return Image.memory(snapshot.data!.bodyBytes);
                      } else if (snapshot.hasError) {
                        return Text('Failed to load image');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
            ]
          ),
        )
    )
    )

    );

  }
}
