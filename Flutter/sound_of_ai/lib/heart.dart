import 'package:sound_of_ai/features.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';

import 'package:get/get.dart';

import 'package:sound_of_ai/loginpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Heart extends StatefulWidget {
  const Heart({Key? key}) : super(key: key);

  @override
  State<Heart> createState() => _HeartState();
}

class _HeartState extends State<Heart> {
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
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


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
  // Future<void> uploadAudio(File audioFile) async {
  //   // final url = 'http://35.154.222.141:80/predict';
  //   // Change this to your Flask back-end URL
  //   // final url = 'http://10.0.2.2:5000/predict';
  //   final url = 'http://16.171.133.237:80/predict';
  //
  //   var request = await http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));
  //   var response = await request.send();
  //   var responseData = await response.stream.bytesToString();
  //   setState(() {
  //     prediction = responseData;
  //   });
  //   debugPrint(responseData);
  // }
  Future<void> uploadAudio(File audioFile) async {
    final url = 'http://16.171.133.237:80/predict';
    // final url = 'http://10.0.2.2:5000/predict';

    var request = await http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    setState(() {
      prediction = responseData;
    });
    debugPrint(responseData);

    await addPredictionToFirestore(responseData);
  }
  Future<void> addPredictionToFirestore(String prediction) async {
    final User? user = _auth.currentUser;
    final String userId = user?.uid ?? '';

    try {
      await _firestore.collection('predictions').add({
        'userId': userId,
        'prediction': prediction,
        'timestamp': DateTime.now(),
      });
      print('Prediction added to Firestore successfully');
    } catch (e) {
      print('Error adding prediction to Firestore: $e');
    }
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
  Future<void> uploadAudio1(File audioFile) async {
    var request = http.MultipartRequest(
      // 'POST', Uri.parse('http://10.0.2.2:5000/graphs'));
        'POST', Uri.parse('http://16.171.133.237/graphs'));
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        audioFile.path,
      ),
    );
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
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
                    SizedBox(height: h*0.3),
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
                        backgroundColor:Color(0xff36363b),
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

                    Text(""),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Visualization",
                            style: TextStyle(
                              color:Color(0xff36363b),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(() => Features()),
                          ),
                        ],
                      ),
                    ),
                  ],

                ),
              )
          ),

        )

    );

  }
}
