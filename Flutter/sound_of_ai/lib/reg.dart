
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import'package:sound_of_ai/loginpage.dart';

import 'package:sound_of_ai/auth_controller.dart';
import 'package:sound_of_ai/phone.dart';

class SignUpPage extends StatelessWidget {

  var emailController =TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){

    List images = [
      "g.png",
      "f.png",
      "t.png",

    ];

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
          children: [
            SizedBox(height: h * 0.2),

          Container(
              margin: const EdgeInsets.only(left:20,right:20),
              width:w,
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sound of AI",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Create an Account",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height:80),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: Offset(1,1),
                              color:Colors.grey.withOpacity(0.2),
                            )
                          ]
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: " Email",
                          prefixIcon: Icon(Icons.email,color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:Colors.white,
                                width:1.0,
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color:Colors.white,
                              width:1.0,
                            ),
                          ) ,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:20,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: Offset(1,1),
                              color:Colors.grey.withOpacity(0.2),
                            )
                          ]
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: " Password",
                          prefixIcon: Icon(Icons.password,color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:Colors.white,
                                width:1.0,
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color:Colors.white,
                              width:1.0,
                            ),
                          ) ,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:20,),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: "Login with Phone Number",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => MyPhone()),
                        ),
                      ),
                    ),


                  ]
              )
          ),
          SizedBox(height:15),
          GestureDetector(
            onTap:(){
              AuthController.instance.register(emailController.text.trim(),passwordController.text.trim());
            },
            child: Container(
              width: w*0.3,
              height:h*0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage(""
                          "assets/black.jpeg"
                      ),
                      fit: BoxFit.cover
                  )
              ),
              child: Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color:Colors.white,
                  ),
                ),
              ),

            ),
          ),
          SizedBox(height:65),
          RichText(text: TextSpan(
              recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>LoginPage()),
              text:"Have an account?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )
          ),
          ),

        ],),

      ),

      )
    );
  }
}
