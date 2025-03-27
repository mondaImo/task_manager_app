import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager_app/services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // final TextEditingController _statusController = TextEditingController();
  final TaskService _taskService = TaskService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;

  Future<void> _createTask() async {
    setState(() => _isLoading = true);

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    // final status = _statusController.text.trim();
    final status = 'open';

    if (title.isEmpty || description.isEmpty || status.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      setState(() => _isLoading = false);
      return;
    }
    final sessionToken = await _storage.read(key: 'sessionToken');
    final userId = await _storage.read(key: 'userId');

    if (sessionToken != null && userId != null) {
      final success = await _taskService.createTask(
        sessionToken,
        title,
        description,
        status,
        userId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task created successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create task.')),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Description'
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            // TextField(
            //   controller: _statusController,
            //   decoration: const InputDecoration(labelText: 'Status'),
            // ),
            // const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _createTask,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}