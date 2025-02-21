abstract class JobDetailsEvent {}

class JobDetailsInitialEvent extends JobDetailsEvent {
  final int selectedIndex;

  JobDetailsInitialEvent({required this.selectedIndex});
}

class OnDropdownSelectionEvent extends JobDetailsEvent {
  final String selectedDropdownValue;

  OnDropdownSelectionEvent({required this.selectedDropdownValue});
}
