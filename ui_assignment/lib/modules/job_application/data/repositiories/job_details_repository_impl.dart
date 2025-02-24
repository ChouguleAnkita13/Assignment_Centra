import 'package:ui_assignment/modules/job_application/domain/repositories/abstarct_job_details_repository.dart';
import 'package:flutter/services.dart';

class JobDetailsRepositoryImpl implements AbstarctJobDetailsRepository {
  @override
  Future<String> getJobDetails() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    return jsonString;
  }
}
