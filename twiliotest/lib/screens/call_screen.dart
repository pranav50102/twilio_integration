// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:twilio_programmable_video/twilio_programmable_video.dart';
// import 'package:twiliotest/twilio/twilio_call_service.dart';
//
// import '../videoCallBLoc/video_call_bloc.dart';
//
// class CallScreen extends StatefulWidget {
//   const CallScreen({super.key});
//
//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen> {
//
//   late TwilioCallService twilioCallService;
//   LocalVideoTrack? video;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     twilioCallService = TwilioCallService();
//     initiateCall();
//     super.initState();
//   }
//
//   void initiateCall() async {
//     print('in initiate call : 1');
//     final room = await twilioCallService.connectToRoom('room_1');
//     video = twilioCallService.getLocalVideo();
//     print('in initiate call : 2');
//     print('video : $video');
//     if (video != null) {
//       print('video is not null');
//     }
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: BlocBuilder<VideoCallBloc, VideoCallState>(
//           builder: (context, state) {
//             return Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Container(
//                   color: Colors.grey,
//                   child: video?.widget() ?? Icon(
//                     Icons.videocam_off,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Positioned(
//                   right: 5,
//                   top: 5,
//                   child: Container(
//                     height: 100,
//                     width: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                     ),
//                     child: twilioCallService.getRemoteVideo() ?? Icon(
//                       Icons.videocam_off,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () async {
//                         await twilioCallService.disconnectCall();
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.call_end),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         )
//     );
//   }
// }
