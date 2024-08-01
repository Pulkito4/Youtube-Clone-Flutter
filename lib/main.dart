import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_clone/screens/main_screen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
 Future <void> main() async {
      await dotenv.load(fileName: "assets/.env");

  runApp( MaterialApp(
    
    home: const HomeScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
  ));
} 

/* 
void main(){
  runApp( MaterialApp(
    
    home: const HomeScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
  ));
} */