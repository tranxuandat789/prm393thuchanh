import 'package:flutter/material.dart';

// Lab 11 - Testing & Debugging
// A simple Todo List app designed for unit, widget, and integration testing.

class TodoItem {
  final String id;
  final String title;
  bool isDone;

  TodoItem({required this.id, required this.title, this.isDone = false});
}

class TodoListManager {
  final List<TodoItem> _items = [];

  List<TodoItem> get items => List.unmodifiable(_items);

  int _counter = 0;

  void addItem(String title) {
    if (title.trim().isEmpty) throw ArgumentError('Title cannot be empty');
    _counter++;
    _items.add(TodoItem(
        id: '${DateTime.now().millisecondsSinceEpoch}_$_counter',
        title: title));
  }

  void toggleItem(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isDone = !_items[index].isDone;
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  int get completedCount => _items.where((item) => item.isDone).length;
}

class Lab11App extends StatelessWidget {
  const Lab11App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 11: Testing & Debugging',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoListManager _manager = TodoListManager();
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    try {
      _manager.addItem(_controller.text);
      _controller.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 11 - Testing & Debugging'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Completed: ${_manager.completedCount}/${_manager.items.length}',
                key: const Key('completed_count'),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('todo_input'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  key: const Key('add_button'),
                  onPressed: _addTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _manager.items.isEmpty
                ? const Center(
                    child:
                        Text('No items yet. Add one!', key: Key('empty_text')),
                  )
                : ListView.builder(
                    itemCount: _manager.items.length,
                    itemBuilder: (context, index) {
                      final item = _manager.items[index];
                      return ListTile(
                        key: Key('item_${item.id}'),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            decoration:
                                item.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        leading: Checkbox(
                          key: Key('checkbox_${item.id}'),
                          value: item.isDone,
                          onChanged: (val) {
                            setState(() {
                              _manager.toggleItem(item.id);
                            });
                          },
                        ),
                        trailing: IconButton(
                          key: Key('delete_${item.id}'),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _manager.removeItem(item.id);
                            });
                          },
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
