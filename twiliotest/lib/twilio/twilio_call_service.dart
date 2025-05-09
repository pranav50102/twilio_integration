import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:twiliotest/identity.dart';
import 'package:twiliotest/twilio/access_tokn.dart';
import 'package:twiliotest/twilio/twilio_chat_service.dart';
import 'package:twiliotest/videoCallBLoc/video_call_bloc.dart';

class TwilioCallService{
  late Room _room;
  final Completer<Room> _completer = Completer<Room>();
  LocalVideoTrack? localVideo ;
  RemoteVideoTrackPublication? remoteVideoWidget;

  void _onConnected(Room room) {
    print('Connected to ${room.name}');
    _completer.complete(_room);
    room.remoteParticipants.first.onVideoTrackSubscribed.listen(
        (RemoteVideoTrackSubscriptionEvent event){
          remoteVideoWidget =  event.remoteParticipant.remoteVideoTracks.first;
          print("if articipant already exists");
          final getIt = GetIt.instance;
          getIt.call<VideoCallBloc>().add(ParticipantConnected());
        }
    );
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    print('Failed to connect to room ${event.room.name} with exception: ${event.exception}');
    _completer.completeError(event.exception as Object);
  }

  Future<Room> connectToRoom(String? roomName) async {
    var cameraSources = await CameraSource.getSources();
    var cameraCapturer = CameraCapturer(
      cameraSources.firstWhere((source) => source.isFrontFacing),
    );
    print('in connectroom');
    var localVideoTrack = LocalVideoTrack(true, cameraCapturer);
    var connectOptions = ConnectOptions(
      accessToken,
      roomName: roomName,                   // Optional name for the room
      // region: region,                       // Optional region.
      // preferredAudioCodecs: [OpusCodec()],  // Optional list of preferred AudioCodecs
      // preferredVideoCodecs: [H264Codec()],  // Optional list of preferred VideoCodecs.
      // audioTracks: [LocalAudioTrack(true,'audio')], // Optional list of audio tracks.
      // dataTracks: [
      //   LocalDataTrack(
      //     DataTrackOptions(
      //         ordered: ordered,                      // Optional, Ordered transmission of messages. Default is `true`.
      //         maxPacketLifeTime: maxPacketLifeTime,  // Optional, Maximum retransmit time in milliseconds. Default is [DataTrackOptions.defaultMaxPacketLifeTime]
      //         maxRetransmits: maxRetransmits,        // Optional, Maximum number of retransmitted messages. Default is [DataTrackOptions.defaultMaxRetransmits]
      //         name: name                             // Optional
      //     ),                                // Optional
      //   ),
      // ],                                    // Optional list of data tracks
      videoTracks: [localVideoTrack], // Optional list of video tracks.
    );
    localVideo = localVideoTrack;
    _room = await TwilioProgrammableVideo.connect(connectOptions);
    _room.onConnected.listen(_onConnected);
    _room.onConnectFailure.listen(_onConnectFailure);
    print('Setting up room listeners...');
    _room.onParticipantConnected.listen(_onParticipantConnected);
    _room.onParticipantDisconnected.listen(_onParticipantDisconnected);

    return _completer.future;
  }

  void _onParticipantConnected(RoomParticipantConnectedEvent event){
    print("new participant connected step 1");
    event.remoteParticipant.onVideoTrackSubscribed.listen((RemoteVideoTrackSubscriptionEvent videoEvent){
      var mirror = false;
      remoteVideoWidget =  videoEvent.remoteParticipant.remoteVideoTracks.first;
      print("new participant connected step 2");
      final getIt = GetIt.instance;
      getIt.call<VideoCallBloc>().add(ParticipantConnected());
    });
  }
  void _onParticipantDisconnected(RoomParticipantDisconnectedEvent event){
    print("new participant connected step 1");
  }

  Future<void> disconnectCall()async{
    await _room.disconnect();
  }

  LocalVideoTrack? getLocalVideo(){
    return localVideo;
  }

  Widget? getRemoteVideo(){
    return remoteVideoWidget?.remoteVideoTrack?.widget(mirror: false) ?? SizedBox();
  }
}