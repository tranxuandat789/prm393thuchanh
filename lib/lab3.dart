import 'dart:async';
import 'dart:convert';

void main() async {
  print("========== Exercise 1 ==========");
  await exercise1();

  print("\n========== Exercise 2 ==========");
  await exercise2();

  print("\n========== Exercise 3 ==========");
  exercise3();

  // Delay để nhìn rõ thứ tự output
  await Future.delayed(Duration(seconds: 1));

  print("\n========== Exercise 4 ==========");
  await exercise4();

  print("\n========== Exercise 5 ==========");
  exercise5();
}

//////////////////////////////////////////////////////////////////
// Exercise 1 – Product Model & Repository
//////////////////////////////////////////////////////////////////

class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return "Product(id: $id, name: $name, price: $price)";
  }
}

class ProductRepository {
  final List<Product> _products = [
    Product(1, "Laptop", 1500),
    Product(2, "Mouse", 25),
  ];

  // Broadcast stream for real-time updates
  final StreamController<Product> _controller =
      StreamController<Product>.broadcast();

  // Return all products asynchronously
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1));
    return _products;
  }

  // Stream for listening new added products
  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  // Add new product and emit event
  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product);
  }
}

Future<void> exercise1() async {
  ProductRepository repo = ProductRepository();

  // Listen for live updates
  repo.liveAdded().listen((product) {
    print("New Product Added: $product");
  });

  // Get all products
  List<Product> products = await repo.getAll();

  print("All Products:");
  for (var p in products) {
    print(p);
  }

  // Add new product
  repo.addProduct(Product(3, "Keyboard", 50));

  await Future.delayed(Duration(seconds: 1));
}

//////////////////////////////////////////////////////////////////
// Exercise 2 – User Repository with JSON
//////////////////////////////////////////////////////////////////

class User {
  String name;
  String email;

  User({required this.name, required this.email});

  // Factory constructor from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return "User(name: $name, email: $email)";
  }
}

class UserRepository {
  Future<List<User>> fetchUsers() async {
    // Simulated API delay
    await Future.delayed(Duration(seconds: 1));

    // Simulated JSON response
    String jsonData = '''
    [
      {"name": "Dat", "email": "dat@gmail.com"},
      {"name": "Anna", "email": "anna@gmail.com"}
    ]
    ''';

    List<dynamic> decoded = jsonDecode(jsonData);

    return decoded.map((e) => User.fromJson(e)).toList();
  }
}

Future<void> exercise2() async {
  UserRepository repo = UserRepository();

  List<User> users = await repo.fetchUsers();

  print("Users:");
  for (var user in users) {
    print(user);
  }
}

//////////////////////////////////////////////////////////////////
// Exercise 3 – Async + Microtask Debugging
//////////////////////////////////////////////////////////////////

void exercise3() {
  print("Start");

  // Event queue
  Future(() {
    print("Future Event");
  });

  // Microtask queue
  scheduleMicrotask(() {
    print("Microtask");
  });

  print("End");

  /*
    Expected order:
    Start
    End
    Microtask
    Future Event

    Explanation:
    Microtasks always execute before normal event queue tasks.
  */
}

//////////////////////////////////////////////////////////////////
// Exercise 4 – Stream Transformation
//////////////////////////////////////////////////////////////////

Future<void> exercise4() async {
  Stream<int> numberStream =
      Stream.fromIterable([1, 2, 3, 4, 5]);

  // Square numbers
  Stream<int> squaredStream =
      numberStream.map((number) => number * number);

  // Filter even squares
  Stream<int> evenSquares =
      squaredStream.where((number) => number % 2 == 0);

  await for (var value in evenSquares) {
    print("Even Square: $value");
  }
}

//////////////////////////////////////////////////////////////////
// Exercise 5 – Factory Constructors & Cache
//////////////////////////////////////////////////////////////////

class Settings {
  // Singleton instance
  static final Settings _instance = Settings._internal();

  // Private constructor
  Settings._internal();

  // Factory constructor
  factory Settings() {
    return _instance;
  }
}

void exercise5() {
  Settings a = Settings();
  Settings b = Settings();

  print("Are a and b identical?");
  print(identical(a, b)); // true
}