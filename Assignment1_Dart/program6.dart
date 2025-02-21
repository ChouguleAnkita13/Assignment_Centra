void main() {
  List emplist = [
    {"id": 1, "name": "Alice", "age": 25},
    {"id": 2, "name": "Bob", "age": 30}
  ];

  for (var data in emplist) {
    print("User ${data["id"]}: ${data["name"]}, ${data["age"]} year old.");
  }
}
