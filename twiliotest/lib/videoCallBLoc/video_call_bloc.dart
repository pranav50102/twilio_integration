
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  VideoCallBloc() : super(VideoCallInitial()) {
    on<ParticipantConnected>((event, emit) {
      print('videoCallAvailable State emitted');
      emit(VideoCallAvailable(isRemoteAvailable: true));
    });
  }
}
