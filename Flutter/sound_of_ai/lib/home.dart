import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_of_ai/urban.dart';
import 'package:sound_of_ai/heart.dart';
import 'package:sound_of_ai/auth_controller.dart';
import 'package:sound_of_ai/loginpage.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Home'),
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.logout),
  //           onPressed: () {
  //             Auth.instance.logOut();
  //             print('Logout pressed');
  //           },
  //         ),
  //       ],
  //     ),
  //     body:
  //     Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => MyHome()),
  //             );
  //           },
  //           child: Card(
  //             child: Padding(
  //               padding: EdgeInsets.all(16.0),
  //               child: Column(
  //                 children: [
  //                   Icon(Icons.file_upload),
  //                   SizedBox(height: 10),
  //                   Text('UrbanSound Classifier'),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => MyWelcome()),
  //             );
  //           },
  //           child: Card(
  //             child: Padding(
  //               padding: EdgeInsets.all(16.0),
  //               child: Column(
  //                 children: [
  //                   Icon(Icons.file_upload),
  //                   SizedBox(height: 10),
  //                   Text('HeartSound Classifier'),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xff36363b),
        title: Text('Home'),
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
      body:SingleChildScrollView(
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.3),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UrbanSound()),
                  );
                },

                child: Center(
                  child:Container(
                    width: w * 0.7,
                    height: h * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: AssetImage("assets/grey.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "UrbanSound Classifier",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Heart()),
                  );
                },
                child: Center(
                  child:Container(
                    width: w * 0.7,
                    height: h * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: AssetImage("assets/grey.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "HeartSound Classifier",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      )

    );
  }


}
