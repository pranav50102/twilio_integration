part of 'video_call_bloc.dart';

@immutable
sealed class VideoCallState {
  final bool? isRemoteAvailable;
  const VideoCallState({
    required this.isRemoteAvailable
});
}

final class VideoCallInitial extends VideoCallState {
  const VideoCallInitial() : super(isRemoteAvailable: null);
}

final class VideoCallAvailable extends VideoCallState{
  const VideoCallAvailable({required bool isRemoteAvailable}) : super(isRemoteAvailable: isRemoteAvailable);
}
