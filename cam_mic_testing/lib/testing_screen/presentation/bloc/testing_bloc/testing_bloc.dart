import 'package:bloc/bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/testing_bloc/testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/testing_bloc/testing_state.dart';

class TestingScreenBloc extends Bloc<TestingScreenEvent, TestingScreenState> {
  TestingScreenBloc()
      : super(TestingScreenState(selectedTabIndex: 0, completedTabs: {})) {
    on<TabChanged>((event, emit) {
      emit(state.copyWith(selectedTabIndex: event.selectedTabIndex));
    });

    on<TabCompleted>((event, emit) {
      final updatedCompletedTabs = Set<int>.from(state.completedTabs)
        ..add(event.index);
      emit(state.copyWith(completedTabs: updatedCompletedTabs));
    });
  }
}
