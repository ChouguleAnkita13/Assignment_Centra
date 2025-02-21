import 'dart:io';

void main() {
  List numList = [];
  print("Enter Length of List=");

  int length = int.parse(stdin.readLineSync()!);
  print("Enter $length Numbers=");

  for (int i = 0; i < length; i++) {
    int num = int.parse(stdin.readLineSync()!);
    numList.add(num);
  }

  int g = numList[0];
  for (int i = 0; i < numList.length; i++) {
    if (g < numList[i]) {
      g = numList[i];
    }
  }

  print("Largest Number from list= $g");
}
