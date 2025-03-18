import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/camera_testing_bloc/camera_testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/camera_testing_bloc/camera_testing_state.dart';
import 'package:webrtc/util/test_session_data.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  CameraBloc() : super(CameraInitial()) {
    on<InitializeCamera>(_initializeCamera);
  }

  Future<void> _initializeCamera(
      InitializeCamera event, Emitter<CameraState> emit) async {
    emit(CameraLoading());

    await _localRenderer.initialize();

    try {
      final mediaStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
      });

      _localRenderer.srcObject = mediaStream;
      await TestSessionData.storeTestSessionData(
          isCameraTest: true,
          isMicTest: TestSessionData.isMicTest,
          isSpeakerTest: TestSessionData.isSpeakerTest);
      emit(CameraSuccess(_localRenderer));
    } catch (e) {
      print("Camera initialization error: $e");
      emit(CameraFailure());
    }
  }

  @override
  Future<void> close() {
    _localRenderer.dispose();
    return super.close();
  }
}
