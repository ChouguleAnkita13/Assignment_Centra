import "dart:io";

void main() {
  print("Enter number of rows");
  int rows = int.parse(stdin.readLineSync()!);
  print("Enter number of columns");
  int col = int.parse(stdin.readLineSync()!);

  List<List<int>> list1 = List.filled(rows, List.filled(col, 0));
  List<List<int>> list2 = List.filled(rows, List.filled(col, 0));
  List<List<int>> list3 = List.filled(rows, List.filled(col, 0));

  if (rows != col) {
    print("The size of rows and column should be same");
  } else {
    print("Enter elements for first list:");
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < col; j++) {
        print("Enter element :");
        list1[i][j] = int.parse(stdin.readLineSync()!);
      }
    }
    print(list1);
    // Taking input for second matrix
    print("Enter elements for second list:");
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < col; j++) {
        print("Enter element :");
        list2[i][j] = int.parse(stdin.readLineSync()!);
      }
    }

    for (int i = 0; i < list1.length; i++) {
      for (int j = 0; j < list1[i].length; j++) {
        list3[i][j] = list1[i][j] + list2[i][j];
      }
    }
    print("Addition of two matrix");
    print(list3);
  }
}
