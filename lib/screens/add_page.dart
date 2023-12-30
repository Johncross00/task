import 'package:flutter/material.dart';
import 'package:task/services/todo_services.dart';

import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddToPageState();
}

class _AddToPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title ?? '';
      descriptionController.text = description ?? '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
      isEdit ? 'Edit Todo' : 'Add Todo'),),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Title'),
            controller: titleController,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            controller: descriptionController,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed:isEdit? updateData : submitData, child: Text( isEdit? "Update" : "Submit")),
        ],
      ),
    );
  }
  Future<void> updateData() async {
    final todo = widget.todo;
    if(todo == null){
      print("No update without todo data");
      return;
    }
    final id = todo['_id'];
    final isCompleted = todo['is_completed'];
  //   final title = titleController.text;
  //   final description = descriptionController.text;
  //   final body = {
  //     "title": title,
  //     "description": description,
  //     "is_completed": false,
  // };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final isSucess = await TodoService.updateTodo(id, body);
    if (isSucess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: "Update Success");
    } else {
      showErrorMessage(context, message: "Update failed");
    }
  }
  Future<void> submitData() async {
    // Get the data from the form
    // final title = titleController.text;
    // final description = descriptionController.text;
    // final body = {
    //   "title": title,
    //   "description": description,
    //   "is_completed": false,
    // };
    print("Submitting data...");  // Add this line


    // Submit to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final isSucess = await TodoService.addTodo(body);
    print("Submitting data to the server...");  // Add this line


    // Show success or fail message based on the status code
    if (isSucess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: "Creation Success");
    } else {
      showErrorMessage(context, message: "Creation failed");
    }
  }

  // void showSuccessMessage(BuildContext context, {required String message}) {
  //   final snackBar = SnackBar(
  //     content: Text(message),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  // void showErrorMessage(BuildContext context) {
  //   final snackBar = SnackBar(
  //     content: Text(
  //       message,
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     backgroundColor: Colors.red,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
Map get body{
  final title = titleController.text;
  final description = descriptionController.text;
  return {
    "title": title,
    "description": description,
    "is_completed": false,
  };
}
}
