void main() {
  List list1 = [1, 2, 3, 4, 5];
  List modifiedList = [];
  for (int i in list1) {
    if (i % 2 != 0) {
      modifiedList.add(i * i);
    }
  }
  print(modifiedList);
}
