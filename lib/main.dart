import 'package:flutter/material.dart';

const String studentName = 'I Putu Budha Aditya';
const String studentId = '2415051006';

void main() {
  runApp(const MyApp());}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter UI Fundamentals', style: TextStyle(fontSize:20, fontWeight: FontWeight.w900)),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName, 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        studentId, 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left, // I Putu Budha Aditya - 2415051006
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: Center(
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Text(
                          'Saya memiliki minat di pemrograman mobile dan mendalami teknologi flutter',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Icon(Icons.code, size: 50),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Column(children: [Text('30'), Text('Widget')]),
                    Column(children: [Text('15'), Text('Layout')]), // I Putu Budha Aditya - 2415051006
                    Column(children: [Text('0'), Text('State')]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}