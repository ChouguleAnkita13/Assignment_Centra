import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraSuccess extends CameraState {
  final RTCVideoRenderer renderer;
  CameraSuccess(this.renderer);
}

class CameraFailure extends CameraState {}
