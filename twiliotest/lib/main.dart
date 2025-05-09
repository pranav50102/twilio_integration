import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twiliotest/screens/InitialScreen.dart';
import 'package:twiliotest/screens/chat_screen.dart';
import 'package:twiliotest/videoCallBLoc/video_call_bloc.dart';
import 'package:get_it/get_it.dart';

void main() {
  final videoCallBloc = VideoCallBloc();
  final getIt = GetIt.instance;
  getIt.registerSingleton<VideoCallBloc>(videoCallBloc);
  runApp(
    BlocProvider.value(
      value: videoCallBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Initialscreen(),
      ),
    ),
  );
}

