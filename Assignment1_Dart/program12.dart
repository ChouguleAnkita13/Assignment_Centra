class Student {
  final int id;
  final String name;
  final Map grade;

  Student({required this.id, required this.name, required this.grade});

  void addGrade(String subject, double marks) {
    grade[subject] = marks;
  }

  double calculateAverage() {
    double totalMarks = 0;
    for (String i in grade.keys) {
      totalMarks += grade[i];
    }
    double avg = totalMarks / grade.length;
    // print("Average= $avg");
    return avg;
  }
}

void main() {
  // Student studObj = Student(
  //     id: 101,
  //     name: "Ankita",
  //     grade: {"Math": 89, "Physics": 69, "Chemistry": 77});

  // studObj.calculateAverage();

  // ///Adding grades
  // studObj.addGrade("English", 98);
  // studObj.calculateAverage();

  List studentList = [
    Student(
        id: 101,
        name: "Ankita",
        grade: {"Math": 89, "Physics": 69, "Chemistry": 77}),
    Student(
        id: 102,
        name: "Neha",
        grade: {"Math": 87, "Physics": 78, "Chemistry": 89}),
  ];
  print("Students with an average grade above a given threshold");
  int topScore = 0;
  String sub = "";
  String studName = "";
  for (Student i in studentList) {
    if (i.calculateAverage() > 80) {
      print(i.name);
    }
    for (var data in i.grade.keys) {
      // print(i.grade[data]);
      if (i.grade[data] > topScore) {
        topScore = i.grade[data];
        sub = data;
        studName = i.name;
      }
    }
  }

  print("Top scorer in a $sub is $studName");
}
