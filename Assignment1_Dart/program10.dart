void main() {
  List list1 = [1, 2, 3, 4, 5];
  int sum = 6;

  List list2 = [];

  for (int i = 0; i < list1.length; i++) {
    for (int j = i; j < list1.length - i; j++) {
      if (list1[i] + list1[j] == sum && i != j) {
        list2.add("(${list1[i]},${list1[j]})");
        print("${list1[i]} ${list1[j]}");
      }
    }
  }
  print(list2);
}
