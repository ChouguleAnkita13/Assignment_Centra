void main() {
  List list1 = [
    [1, 2],
    [3, 4],
    [
      5,
      [6, 7]
    ]
  ];

  List flattenedList = [];
  flattenList(list1, flattenedList);
  print(flattenedList); // Output: [1, 2, 3, 4, 5, 6, 7]
}

void flattenList(List<dynamic> nestedList, List<dynamic> result) {
  for (var element in nestedList) {
    if (element is List) {
      flattenList(element, result);
    } else {
      result.add(element);
    }
  }
}
