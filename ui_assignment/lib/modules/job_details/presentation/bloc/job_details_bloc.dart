import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:ui_assignment/modules/job_details/data/models/job_details_response_model.dart';
import 'package:ui_assignment/modules/job_details/domain/usecases/job_details_usecase.dart';
import 'package:ui_assignment/modules/job_details/presentation/bloc/job_details_event.dart';
import 'package:ui_assignment/modules/job_details/presentation/bloc/job_details_state.dart';

class JobDetailsBloc extends Bloc<JobDetailsEvent, JobDetailsState> {
  JobDetailsBloc() : super(JobDetailsInitialState()) {
    on<JobDetailsInitialEvent>(jobDetailsInitialEvent);
    on<OnDropdownSelectionEvent>(onDropdownSelectionEvent);
  }

  FutureOr jobDetailsInitialEvent(
      JobDetailsInitialEvent event, Emitter<JobDetailsState> emit) async {
    ///USESCASE INVOKE METHOD CALLED
    JobDetailsUsecase jobDetailsUsecase = JobDetailsUsecase();
    String jsonString = await jobDetailsUsecase.invoke();

    ///PASSING THE JSONSTRING TO jobDetailsResponseModelFromJson(jsonString)
    ///WHICH CONVERTS THE JSONSTRING INTO JSONOBJECT AND RETURNS MODELCLASS OBJECT
    ///BY CONVERTING JSONOBJECT INTO MODELCLASSOBJECT
    List<JobDetailsResponseModel> jobDetailsResponseModelList =
        jobDetailsResponseModelFromJson(jsonString);

    ///GET SPECIFIC MODEL CLASS DATA
    JobDetailsResponseModel? jobDetailsResponseModel;
    for (var data in jobDetailsResponseModelList) {
      if (data.role == "UI Designer") {
        jobDetailsResponseModel = data;
        break;
      }
    }
    if (jsonString.isEmpty || jobDetailsResponseModel == null) {
      log("Emit Error State");
      emit(JobDetailsErrorState());
    } else {
      log("Emit Success State ${event.selectedIndex}");

      emit(JobDetailsSuccessState(
          jobDetails: jobDetailsResponseModel,
          selectedDropdownValue: "UI Designer",
          selectedIndex: event.selectedIndex));
    }
  }

  /// ON DROPDOWN EVENT
  FutureOr onDropdownSelectionEvent(
      OnDropdownSelectionEvent event, Emitter<JobDetailsState> emit) async {
    ///USESCASE INVOKE METHOD CALLED
    JobDetailsUsecase jobDetailsUsecase = JobDetailsUsecase();
    String jsonString = await jobDetailsUsecase.invoke();

    ///PASSING THE JSONSTRING TO jobDetailsResponseModelFromJson(jsonString)
    ///WHICH CONVERTS THE JSONSTRING INTO JSONOBJECT AND RETURNS MODELCLASS OBJECT
    ///BY CONVERTING JSONOBJECT INTO MODELCLASSOBJECT

    List<JobDetailsResponseModel> jobDetailsResponseModelList =
        jobDetailsResponseModelFromJson(jsonString);

    ///GET SPECIFIC MODEL CLASS
    JobDetailsResponseModel? jobDetailsResponseModel;
    for (var data in jobDetailsResponseModelList) {
      if (data.role == event.selectedDropdownValue) {
        jobDetailsResponseModel = data;
        break;
      }
    }
    if (jsonString.isEmpty || jobDetailsResponseModel == null) {
      log("Emit Error State");
      emit(JobDetailsErrorState());
    } else {
      log("Emit Success State ${event.selectedDropdownValue}");

      emit(JobDetailsSuccessState(
        jobDetails: jobDetailsResponseModel,
        selectedDropdownValue: event.selectedDropdownValue,
      ));
    }
  }
}
