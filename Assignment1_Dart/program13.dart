class Product {
  final int id;
  final String name;
  final double price;
  final int quantity;

  const Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity});
}

class Cart {
  List productList = [
    const Product(id: 101, name: "Laptop", price: 75000, quantity: 1),
    const Product(id: 102, name: "Mobile", price: 45000, quantity: 2)
  ];

  ///
  void addProduct(Product product) {
    productList.add(product);
    print("${product.name} added in List");
    displayAllProducts();
  }

  ///
  void removeProduct(Product product) {
    productList.remove(product);
    print("${product.name} removed from List");
    displayAllProducts();
  }

  void calculateTotalCost() {
    double totalCost = 0;
    for (Product i in productList) {
      totalCost += totalCost + (i.price * i.quantity);
    }
    print("Total Cost of the cart $totalCost");
  }

  ///
  void displayAllProducts() {
    for (Product i in productList) {
      print(
          "Id: ${i.id} , Name: ${i.name},Price: ${i.price} , Quantity:${i.quantity}");
    }
  }
}

void main() {
  Cart cartObj = Cart();

  cartObj.displayAllProducts();
  cartObj.calculateTotalCost();

  ///
  cartObj
      .addProduct(Product(id: 103, name: "Tablet", price: 60000, quantity: 2));

  ///
  cartObj.removeProduct(
      Product(id: 102, name: "Mobile", price: 45000, quantity: 2));
}
