import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Lab 12 - Performance Optimization & Deployment
// A Heavy List app optimized using ListView.builder, const constructors,
// and compute isolates for heavy calculations to avoid UI thread block.

class Lab12App extends StatelessWidget {
  const Lab12App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 12: Performance & Deployment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OptimizedHeavyListScreen(),
    );
  }
}

class OptimizedHeavyListScreen extends StatefulWidget {
  const OptimizedHeavyListScreen({super.key});

  @override
  State<OptimizedHeavyListScreen> createState() => _OptimizedHeavyListScreenState();
}

class _OptimizedHeavyListScreenState extends State<OptimizedHeavyListScreen> {
  final List<String> _items = List.generate(10000, (i) => 'Item $i');
  bool _isCalculating = false;
  int? _calculationResult;

  // Simulate a heavy computation (e.g. complex data parsing or image processing)
  static int _heavyComputation(int iterations) {
    int sum = 0;
    for (int i = 0; i < iterations; i++) {
      sum += i;
    }
    return sum;
  }

  void _runHeavyTask() async {
    setState(() {
      _isCalculating = true;
    });

    // OPTIMIZATION: Offload heavy work to background isolate using compute
    final result = await compute(_heavyComputation, 100000000);

    setState(() {
      _calculationResult = result;
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 12 - Performance Optimized'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _isCalculating ? null : _runHeavyTask,
            tooltip: 'Run heavy compute in background',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isCalculating)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          if (_calculationResult != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Computation Result: $_calculationResult',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            // OPTIMIZATION: ListView.builder builds items on demand instead of all at once
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                // OPTIMIZATION: Using const for widgets that don't change
                return ListItemWidget(title: _items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// OPTIMIZATION: Extracted widget with const constructor to prevent unnecessary rebuilds
class ListItemWidget extends StatelessWidget {
  final String title;

  const ListItemWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.star),
      ),
      title: Text(title),
      subtitle: const Text('Optimized list item with const'),
    );
  }
}
