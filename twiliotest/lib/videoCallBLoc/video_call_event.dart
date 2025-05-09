part of 'video_call_bloc.dart';

@immutable
sealed class VideoCallEvent {

}

final class ParticipantConnected extends VideoCallEvent{
}
