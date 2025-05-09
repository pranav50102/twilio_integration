import 'package:flutter/material.dart';
import 'package:twiliotest/screens/call_screen.dart';
import 'package:twiliotest/screens/chat_screen.dart';

class Initialscreen extends StatefulWidget {
  const Initialscreen({super.key});

  @override
  State<Initialscreen> createState() => _InitialscreenState();
}

class _InitialscreenState extends State<Initialscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder:(context){
                      return ChatScreen();
                    }),
                  );
                },
                child: Text('chat'),
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder:(context){
                      return CallScreen();
                    }),
                  );
                },
                child: Text('call'),
            ),
          ],
        ),
      ),
    );
  }
}
