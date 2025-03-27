import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager_app/screens/add_task_screen.dart';
import 'package:task_manager_app/screens/edit_task_screen.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/services/task_service.dart';
import 'package:task_manager_app/widgets/elevated_card.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<dynamic> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final sessionToken = await _storage.read(key: 'sessionToken');
    if (sessionToken != null) {
      final tasks = await _taskService.getTasks(sessionToken);
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (result == true) {
      _loadTasks(); 
    }
  }

  Future<void> _navigateToEditTask(Map<String, dynamic> task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );

    if (result == true) {
      _loadTasks();
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    await _storage.deleteAll();
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return GestureDetector(
                  onTap: () => _navigateToEditTask(task),
                  child: ElevatedCard(task: task),
                );
              },
            )
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}