class TestingScreenState {
  final int selectedTabIndex;
  final Set<int> completedTabs;

  TestingScreenState({required this.selectedTabIndex, required this.completedTabs});

  TestingScreenState copyWith({int? selectedTabIndex, Set<int>? completedTabs}) {
    return TestingScreenState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      completedTabs: completedTabs ?? this.completedTabs,
    );
  }
}