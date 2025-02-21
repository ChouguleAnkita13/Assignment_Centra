void main() {
  List list1 = [1, 2, 3, 4];
  List list2 = [2, 2, 3, 4, 5, 6];
  List uniqueList = list1;

  for (var i in list2) {
    if (!list1.contains(i)) {
      uniqueList.add(i);
    }
  }
  print(uniqueList);
}
