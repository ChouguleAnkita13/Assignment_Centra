import 'package:ui_assignment/modules/job_application/data/repositiories/job_details_repository_impl.dart';

class JobDetailsUsecase {
  Future invoke() async {
    JobDetailsRepositoryImpl jobDetailsRepositoryImpl =
        JobDetailsRepositoryImpl();

    String jsonString = await jobDetailsRepositoryImpl.getJobDetails();
    return jsonString;
  }
}
