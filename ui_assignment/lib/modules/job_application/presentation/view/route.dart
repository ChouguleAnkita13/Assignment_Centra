import 'package:go_router/go_router.dart';
import 'package:ui_assignment/modules/job_application/presentation/pages/job_details_page.dart';
import 'package:ui_assignment/modules/job_application/presentation/view/mobileview/basic_information.dart';
import 'package:ui_assignment/modules/job_application/presentation/view/mobileview/education_details.dart';
import 'package:ui_assignment/modules/job_application/presentation/view/mobileview/job_details_mobile.dart';
import 'package:ui_assignment/modules/job_application/presentation/view/mobileview/technical_skills.dart';
import 'package:ui_assignment/modules/job_application/presentation/view/mobileview/upload_resume.dart';

final routerConfig = GoRouter(initialLocation: '/job-details', routes: [
  GoRoute(
    name: 'job-details',
    path: '/job-details',
    builder: (context, state) => JobDetailsPage(),
  ),
  GoRoute(
    name: 'job-details-mobile',
    path: '/job-details-mobile',
    builder: (context, state) => JobDetailsMobile(),
  ),
  GoRoute(
    name: 'basic-info',
    path: '/basic-info',
    builder: (context, state) => BasicInformation(),
  ),
  GoRoute(
    name: 'edu-details',
    path: '/edu-details',
    builder: (context, state) => EducationDetails(),
  ),
  GoRoute(
    name: 'tech-skills',
    path: '/tech-skills',
    builder: (context, state) => TechnicalSkills(),
  ),
  GoRoute(
    name: 'upload-resume',
    path: '/upload-resume',
    builder: (context, state) => UploadResume(),
  ),
]);
