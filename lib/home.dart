import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistence/service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController=TextEditingController();
  Map<String,bool> todolist={};
  
  @override
  void initState() {
    getTodosFromFile();
    super.initState();
  }

  void getTodosFromFile() async {
    final dir=await getApplicationDocumentsDirectory();
    try {
      final todos=await AppService().readFromFile("${dir.path}/todos.json");
      setState(() {todolist = todos;});
    } catch (e){
      log("Error while getting Todos from file = $e");
    }
  }

  void saveTodosToFile() async {
    final dir=await getApplicationDocumentsDirectory();
    try {
      await AppService().saveToFile("${dir.path}/todos.json", todolist);
    } catch (e){
      log("Error while Saving Todos to file= $e");
    }
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a Todo"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter your Todo:"),
        ),
        actions: [
          TextButton(
            onPressed: (){
              textController.clear();
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () {
              if (textController.text!=""){
                setState(() {todolist[textController.text]=false;});
                saveTodosToFile();
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: ListView.builder(
          itemCount: todolist.length,
          itemBuilder: (context,index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(4.0,4.0),
                      blurRadius: 8,
                      spreadRadius: 1.0,
                    ),
                    const BoxShadow(
                      color: Colors.white10,
                      offset: Offset(-4.0,-4.0),
                      blurRadius: 8,
                      spreadRadius: 1.0,
                    ),
                  ]
                ),
                child: ListTile(
                  title: Text(todolist.keys.toList()[index],),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {todolist[todolist.keys.toList()[index]]=!todolist.values.toList()[index];});
                      saveTodosToFile();
                    },
                    icon: todolist.values.toList()[index]
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  ),
                ),
              ),
            );
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTodo,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
