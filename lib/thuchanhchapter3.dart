// =============================
// 1. ABSTRACT CLASS
// =============================
import 'dart:async';

abstract class Shape {
  double area();
}

class Circle extends Shape {
  final double r;

  Circle(this.r);

  @override
  double area() => 3.14 * r * r;
}

void abstractDemo() {
  Circle c = Circle(5);
  print("Area = ${c.area()}");
}

// =============================
// 2. IMPLEMENTS
// =============================

class Bird {
  void fly() => print("Bird flying");
}

class Eagle implements Bird {
  @override
  void fly() => print("Eagle gliding");
}

void implementsDemo() {
  Eagle e = Eagle();
  e.fly();
}

// =============================
// 3. MIXIN
// =============================

mixin Logger {
  void log(String msg) {
    print("[LOG] $msg");
  }
}

class AuthService with Logger {
  void login() {
    log("Login success");
  }
}

void mixinDemo() {
  AuthService().login();
}

// =============================
// 4. MIXIN CONSTRAINT
// =============================

class Pet {
  String name;

  Pet(this.name);
}

mixin CanBark on Pet {
  void bark() {
    print("$name says woof!");
  }
}

class Dog extends Pet with CanBark {
  Dog() : super("Buddy");
}

void mixinConstraintDemo() {
  Dog().bark();
}

// =============================
// 5. FACTORY CONSTRUCTOR
// =============================

class User {
  final String name;

  User._(this.name);

  factory User.fromJson(Map<String, dynamic> json) {
    return User._(json['name']);
  }
}

void factoryDemo() {
  var user = User.fromJson({"name": "Dat"});
  print(user.name);
}

// =============================
// 6. GENERIC CLASS
// =============================

class Box<T> {
  T value;

  Box(this.value);

  void show() {
    print("Value = $value");
  }
}

void genericDemo() {
  Box<int>(10).show();
  Box<String>("Hello").show();
}

// =============================
// 7. GENERIC CONSTRAINT
// =============================

abstract class Animal {
  String sound();
}

class Cat extends Animal {
  @override
  String sound() => "Meow";
}

class AnimalBox<T extends Animal> {
  T pet;

  AnimalBox(this.pet);

  void play() {
    print(pet.sound());
  }
}

void genericConstraintDemo() {
  AnimalBox<Cat>(Cat()).play();
}

// =============================
// 8. COLLECTION IF / FOR / SPREAD
// =============================

void collectionDemo() {
  var base = [1, 2, 3];

  var list = [...base, if (true) 99, for (var x in base) x * 10];

  print(list);
}

// =============================
// 9. CUSTOM EXCEPTION
// =============================

class LoginException implements Exception {
  final String msg;

  LoginException(this.msg);

  @override
  String toString() => msg;
}

void login(String password) {
  if (password != "123") {
    throw LoginException("Wrong password");
  }
}

void exceptionDemo() {
  try {
    login("111");
  } catch (e) {
    print(e);
  }
}

// =============================
// 10. EVENT LOOP & MICROTASK
// =============================

void eventLoopDemo() {
  print("A");

  Future.microtask(() => print("micro"));

  Future(() => print("future"));

  print("B");
}

// =============================
// 11. FUTURE CHAINING
// =============================

void futureChainDemo() {
  Future(() => 1).then((v) => v + 1).then((v) => print(v));
}

// =============================
// 12. STREAM + ASYNC* + YIELD
// =============================

Stream<int> nums() async* {
  for (int i = 1; i <= 3; i++) {
    yield i;
  }
}

Future<void> streamDemo() async {
  await for (var n in nums()) {
    print(n);
  }
}

// =============================
// 13. STREAM CONTROLLER BROADCAST
// =============================

void broadcastDemo() {
  var c = StreamController.broadcast();

  c.stream.listen((v) => print("A: $v"));
  c.stream.listen((v) => print("B: $v"));

  c.add(1);
  c.add(2);
}

// =============================
// 14. REPOSITORY PATTERN (FUTURE)
// =============================

class Repo {
  Future<String> getUser() async {
    await Future.delayed(Duration(milliseconds: 300));
    return "Anna";
  }
}

Future<void> repoFutureDemo() async {
  Repo repo = Repo();

  print(await repo.getUser());
}

// =============================
// 15. REPOSITORY PATTERN (STREAM)
// =============================

Stream<int> counter() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(milliseconds: 300));
    yield i;
  }
}

Future<void> repoStreamDemo() async {
  await for (var v in counter()) {
    print(v);
  }
}

// =============================
// 16. FINAL PRACTICE TASK
// =============================

class Product {
  final int id;
  final String name;

  Product(this.id, this.name);

  @override
  String toString() {
    return "Product(id: $id, name: $name)";
  }
}

class ProductRepository {
  Future<List<Product>> getProducts() async {
    await Future.delayed(Duration(seconds: 1));

    return [
      Product(1, "Laptop"),
      Product(2, "Mouse"),
      Product(3, "Keyboard"),
    ];
  }

  Stream<Product> streamProducts() async* {
    List<Product> products = [
      Product(1, "Laptop"),
      Product(2, "Mouse"),
      Product(3, "Keyboard"),
    ];

    for (var product in products) {
      await Future.delayed(Duration(seconds: 1));
      yield product;
    }
  }
}

Future<void> practiceTaskDemo() async {
  ProductRepository repo = ProductRepository();

  print("=== FUTURE PRODUCTS ===");

  List<Product> products = await repo.getProducts();

  for (var p in products) {
    print(p);
  }

  print("=== STREAM PRODUCTS ===");

  await for (var p in repo.streamProducts()) {
    print(p);
  }
}

// =============================
// MAIN
// =============================

Future<void> main() async {
  abstractDemo();

  implementsDemo();

  mixinDemo();

  mixinConstraintDemo();

  factoryDemo();

  genericDemo();

  genericConstraintDemo();

  collectionDemo();

  exceptionDemo();

  eventLoopDemo();

  futureChainDemo();

  await streamDemo();

  broadcastDemo();

  await repoFutureDemo();

  await repoStreamDemo();

  await practiceTaskDemo();
}
