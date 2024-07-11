import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(secondary: Colors.amber),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(),
      },
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> tasks = [
    {'task': 'Complete Flutter project', 'completed': false},
    {'task': 'Write blog post', 'completed': false},
    {'task': 'Read a book', 'completed': false},
    {'task': 'Go for a walk', 'completed': false},
  ];

  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        tasks.add({'task': _taskController.text, 'completed': false});
        _taskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleCompletion(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
    });
  }

  void _editTask(int index) {
    _taskController.text = tasks[index]['task'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _taskController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tasks[index]['task'] = _taskController.text;
                  _taskController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'New Task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        tasks[index]['task'],
                        style: TextStyle(
                          decoration: tasks[index]['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          tasks[index]['completed']
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () => _toggleCompletion(index),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTask(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(index),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: tasks[index]['task'],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String task = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 100, color: Colors.deepPurple),
              SizedBox(height: 20),
              Text(
                'Details for:',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                task,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
