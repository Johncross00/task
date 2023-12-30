
import 'package:flutter/material.dart';
import 'package:task/screens/add_page.dart';
import 'package:task/services/todo_services.dart';
import 'package:task/widget/todo_card.dart';

import '../utils/snackbar_helper.dart';
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: items.isEmpty
            ? Center(
          child: Text('No items available.', style: Theme.of(context).textTheme.headlineLarge,),
        )
            : RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return TodoCard(index: index,
                  item: item,
                  navigateEdit: navigateToEditPage,
                  deleteById: deleteById);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await navigateToAddPage();
          }, label: Text("Add Todo")),
    );
  }
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage()
    );
   await Navigator.push(context, route);
   setState(() {
     isLoading = true;
   });
   fetchTodo();
  }
  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async{
    //delete the item
    // final url = 'https://api.nstack.in/v1/todos/$id';
    // final uri = Uri.parse(url);
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      //delete the item
      final filtered  = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
      showSuccessMessage('item deleted successfully');
    }else{
      //show the error
      showErrorMessage(context, message: 'Deletion failed');
    }
    //remove the item
  }
  Future<void> fetchTodo() async {
    print("Fetching todo...");  // Add this line
    // setState(() {
    //   isLoading = true;
    // });

    // final url ='https://api.nstack.in/v1/todos?page=1&limit=10';
    // final uri = Uri.parse(url);
    final response = await TodoService.fetchTodos();
   if (response != null) {
     setState(() {
       items = response;
     });
   }else {
     showErrorMessage(context, message: 'Something went wrong');
   }
   setState(() {
     isLoading = false;
   });
    //  print(response.statusCode);
    // print(response.body);
  }
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//   void showErrorMessage(String message) {
//     final snackBar = SnackBar(
//       content: Text(
//         message,
//         style: TextStyle(color: Colors.white),
//       ),
//       backgroundColor: Colors.red,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
}
