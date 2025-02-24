class JobDetailsModel {
  String role;
  String location;
  String work;
  String time;
  List<Menu> menu;
  double salary;

  JobDetailsModel({
    required this.role,
    required this.location,
    required this.work,
    required this.time,
    required this.menu,
    required this.salary,
  });
}

class Menu {
  String name;
  List<String> list;

  Menu({
    required this.name,
    required this.list,
  });
}
