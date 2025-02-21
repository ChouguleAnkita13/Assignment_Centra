import "dart:io";

void main() {
  int num1 = int.parse(stdin.readLineSync()!);
  int num2 = int.parse(stdin.readLineSync()!);

  print("Addition of two numbers= ${addition(num1, num2)}");
  print("Subtraction of two numbers= ${subtraction(num1, num2)}");
  print("Division of two numbers= ${division(num1, num2)}");
  print("Multiplication of two numbers= ${multi(num1, num2)}");
}

int addition(int num1, int num2) {
  return num1 + num2;
}

int subtraction(int num1, int num2) {
  return num1 - num2;
}

int division(int num1, int num2) {
  return num1 ~/ num2;
}

int multi(int num1, int num2) {
  return num1 * num2;
}
