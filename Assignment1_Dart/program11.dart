void main() {
  Map map1 = {"a": 1, "b": 2, "c": 3};

  Map map2 = {"b": 3, "c": 4, "d": 5};

  Map map3 = map1;

  for (var i in map2.keys) {
    if (map3.containsKey(i)) {
      map3[i] = map1[i] + map2[i];
    }
    if (!map3.containsKey(i)) {
      map3[i] = map2[i];
    }
  }
  print(map3);
}
