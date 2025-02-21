import 'dart:io';

void main() {
  print("Enter number of columns");
  int radius = int.parse(stdin.readLineSync()!);
  Circle circleObj = Circle(radius: radius);
  Rectangle rectObj = Rectangle();
  Triangle triObj = Triangle();

  circleObj.area();
  rectObj.area();
  triObj.area();
}

abstract class Shape {
  void area();
}

class Circle extends Shape {
  final int radius;
  Circle({required this.radius});
  void area() {
    print("Area of Circle is=${3.14 * radius * radius}");
  }
}

class Rectangle extends Shape {
  int length = 14;
  int breadth = 25;
  void area() {
    print("Area of Reactangle is=${length * breadth}");
  }
}

class Triangle extends Shape {
  int base = 14;
  int height = 25;
  void area() {
    print("Area of Triangle is=${0.5 * base * height}");
  }
}
