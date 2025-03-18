// Events
import 'package:equatable/equatable.dart';

abstract class TestingScreenEvent extends Equatable {
  const TestingScreenEvent();

  @override
  List<Object> get props => [];
}

class TabChanged extends TestingScreenEvent {
  final int selectedTabIndex;

  const TabChanged(this.selectedTabIndex);

  @override
  List<Object> get props => [selectedTabIndex];
}

class TabCompleted extends TestingScreenEvent {
  final int index;
  const TabCompleted(this.index);
}
