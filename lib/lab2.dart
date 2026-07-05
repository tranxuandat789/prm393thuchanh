void exercise1() {
  int age = 20;
  double height = 1.75;
  String name = "Dat";
  bool isStudent = true;
  print("Name: $name");
  print("Age: $age");
  print("Height: $height");
  print("Student: $isStudent");
  print("Next year age: ${age + 1}");
}

void exercise2() {
  List<int> numbers = [1, 2, 3, 4];
  print("Original list: $numbers");
  numbers.add(5);
  numbers.remove(2);
  print("Updated list: $numbers");
  print("First element: ${numbers[0]}");
  int a = 10;
  int b = 5;
  print("a + b = ${a + b}");
  print("a - b = ${a - b}");
  print("a == b : ${a == b}");
  print("a > b && b < 10 : ${a > b && b < 10}");
  String result = a > b ? "a is bigger" : "b is bigger";
  print(result);
  Set<String> fruits = {"Apple", "Banana", "Apple"};
  print("Set values: $fruits");
  Map<String, int> scores = {"Math": 9, "English": 8};
  print("Math score: ${scores["Math"]}");
}

int add(int a, int b) {
  return a + b;
}

int multiply(int a, int b) => a * b;

void exercise3() {
  int score = 85;
  if (score >= 90) {
    print("Excellent");
  } else if (score >= 70) {
    print("Good");
  } else {
    print("Need improvement");
  }

  String day = "Monday";
  switch (day) {
    case "Monday":
      print("Start of week");
      break;

    case "Friday":
      print("Weekend soon");
      break;

    default:
      print("Normal day");
  }
  for (int i = 1; i <= 3; i++) {
    print("For loop: $i");
  }
  List<String> names = ["A", "B", "C"];
  for (String name in names) {
    print("For-in: $name");
  }
  names.forEach((name) {
    print("forEach: $name");
  });
  print("Add: ${add(3, 4)}");
  print("Multiply: ${multiply(3, 4)}");
}

class Car {
  String brand;
  Car(this.brand);
  Car.defaultCar() : brand = "Toyota";
  void display() {
    print("Car brand: $brand");
  }
}

class ElectricCar extends Car {
  ElectricCar(String brand) : super(brand);
  @override
  void display() {
    print("Electric car brand: $brand");
  }
}

void exercise4() {
  Car car1 = Car("Honda");
  car1.display();

  Car car2 = Car.defaultCar();
  car2.display();

  ElectricCar tesla = ElectricCar("Tesla");
  tesla.display();
}

Future<void> loadData() async {
  print("Loading data...");
  await Future.delayed(Duration(seconds: 2));
  print("Data loaded");
}

Future<void> exercise5() async {
  await loadData();
  String? name;
  print(name ?? "Default Name");
  name = "Dat";
  print(name!);
  Stream<int> numberStream =
      Stream.periodic(Duration(seconds: 1), (x) => x).take(5);
  await for (int value in numberStream) {
    print("Stream value: $value");
  }
}

void main() async {
  print("===== Exercise 1 =====");
  exercise1();

  print("\n===== Exercise 2 =====");
  exercise2();

  print("\n===== Exercise 3 =====");
  exercise3();

  print("\n===== Exercise 4 =====");
  exercise4();

  print("\n===== Exercise 5 =====");
  await exercise5();
}
