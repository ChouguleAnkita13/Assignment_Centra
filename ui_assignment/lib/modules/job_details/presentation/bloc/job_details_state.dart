import 'package:ui_assignment/modules/job_details/data/models/job_details_response_model.dart';

abstract class JobDetailsState {}

class JobDetailsInitialState extends JobDetailsState {}

class JobDetailsSuccessState extends JobDetailsState {
  final JobDetailsResponseModel jobDetails;
  final int? selectedIndex;
  final String? selectedDropdownValue;

  JobDetailsSuccessState(
      {required this.jobDetails,
      this.selectedIndex,
      this.selectedDropdownValue});
}

class JobDetailsErrorState extends JobDetailsState {}
