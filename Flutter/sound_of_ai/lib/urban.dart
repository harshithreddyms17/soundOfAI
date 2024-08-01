// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:loginregpage/loginpage.dart';
//
// class UrbanSound extends StatelessWidget {
//   const UrbanSound({Key? key}) : super(key: key);
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

class UrbanSound extends StatefulWidget {
  const UrbanSound({Key? key}) : super(key: key);

  @override
  State<UrbanSound> createState() => _WelcomeState();
}

class _WelcomeState extends State<UrbanSound> {
  String? _filePath;
  String? predicted;
  String prediction='';
  AudioPlayer audioPlayer= AudioPlayer();
  AudioPlayer audioPlayer1= AudioPlayer();
  bool isPlaying=false;
  bool isPlaying1=false;
  Duration durationSeconds = Duration.zero;
  Duration currentSeconds = Duration.zero;
  Duration durationSeconds1 = Duration.zero;
  Duration currentSeconds1 = Duration.zero;
  int flag=0;
  int flag1=0;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        durationSeconds = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        currentSeconds = newPosition;
      });
    });

    audioPlayer1.onDurationChanged.listen((newDuration1) {
      setState(() {
        durationSeconds1 = newDuration1;
      });
    });
    audioPlayer1.onPositionChanged.listen((newPosition1) {
      setState(() {
        currentSeconds1 = newPosition1;
      });
    });
    audioPlayer1.onPlayerStateChanged.listen((state1) {
      setState((){
        isPlaying1= state1 == PlayerState.playing;
      });
    });
  }
  @override
  void dispose()
  {
    audioPlayer.dispose();
    super.dispose();
  }
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }
  Future<void> uploadAudio(File audioFile) async {
    // final url = 'http://35.154.222.141:80/predict';
    // Change this to your Flask back-end URL
    final url = 'http://16.171.133.237:80/predict_1';
    // final url = 'http://16.171.133.237:80/predict';

    var request = await http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    setState(() {
      prediction = responseData;
    });
    debugPrint(responseData);
  }
  Future<void> pickWavFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      // final audioFile = File (file.path??"");
      // await audioPlayer.setSourceUrl(audioFile.path);
      setState(() {
        _filePath = file.path;
        flag1=1;
        // currentSeconds = Duration.zero;
        // audioPlayer.getDuration().then((duration)=>{
        //   durationSeconds = duration
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Color(0xff36363b),
          title: Text('UrbanSound Classifier'),

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
                SizedBox(height: h * 0.35),
                ElevatedButton(
                  onPressed: pickWavFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xff36363b),
                  ),
                  child: Text('Select .wav file'),
                ),
                SizedBox(height: 10),
                _filePath != null
                    ? Text('Selected file: $_filePath')
                    : Text('No file selected'),
                if (flag1 == 1) ...[
                  Slider(
                    value: currentSeconds.inSeconds.toDouble(),
                    min: 0,
                    max: durationSeconds.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final currentSeconds = Duration(seconds: value.toInt());
                      await audioPlayer1.seek(currentSeconds);
                      await audioPlayer1.resume();
                    },
                    activeColor: Color(0xff36363b),
                    inactiveColor: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(currentSeconds)),
                        Text(formatTime(durationSeconds)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xff36363b),
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 25,
                      color: Colors.grey,
                      onPressed: () async {
                        if (isPlaying) {
                          setState(() {
                            isPlaying = false;
                          });
                          await audioPlayer.pause();
                        } else {
                          setState(() {
                            isPlaying = true;
                          });
                          File audioFile = File(_filePath ?? "");
                          await audioPlayer.play(UrlSource(audioFile.path));
                        }
                      },
                    ),
                  ),
                ],
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await uploadAudio(File(_filePath ?? ""));
                    flag = 1;
                  },
                  child: Text('Predict'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xff36363b),
                  ),
                ),
                SizedBox(height: 20),
                prediction != ''
                    ? Text('Prediction: $prediction')
                    : Text(''),
                flag==1?Column(
                  children: [
                    Slider(
                      activeColor: Color(0xff36363b),
                      inactiveColor: Colors.grey,
                      min: 0,
                      max: durationSeconds1.inSeconds.toDouble(),
                      value: currentSeconds1.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final position1=Duration(seconds: value.toInt());
                        await audioPlayer1.seek(position1);
                        await audioPlayer1.resume();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text(formatTime(currentSeconds1)),
                            Text(formatTime(durationSeconds1)),
                          ]
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor:Color(0xff36363b),
                      radius: 20,
                      child: IconButton(
                        icon: Icon(
                          isPlaying1 ? Icons.pause:Icons.play_arrow,
                        ),
                        iconSize: 25,
                        color: Colors.grey,
                        onPressed: () async {
                          if(isPlaying1){
                            await audioPlayer1.pause();
                          }else{
                            await audioPlayer1.play(AssetSource('$prediction.wav'));
                          }
                        },
                      ),
                    ),
                  ],
                ):Text(''),

              ],

            ),
          )
          ),


        )

    );

  }
}
