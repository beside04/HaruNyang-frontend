import 'package:get/get.dart';

enum Job {
  student,
  jobSeeker,
  officeWorkers,
  freelancer,
  etc,
}

class OnBoardingJobViewModel extends GetxController {
  final Rx<Job> jobStatus = Job.student.obs;
  final List jobList = ["학생", "취준생", "직장인", "프리랜서", "기타"].obs;
}
