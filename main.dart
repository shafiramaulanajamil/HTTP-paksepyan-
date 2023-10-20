import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FORM",
      home: GetDataTodos(),
    );
  }
}

Future<List<Todo>> fetchTodos() async {
  final response = await http
      .get(Uri.parse('https://calm-plum-jaguar-tutu.cyclic.app/todos'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body)['data'];
    List<Todo> todos = body.map((item) => Todo.fromJson(item)).toList();
    return todos;
  } else {
    throw Exception('Failed to load Todos');
  }
}

class Todo {
  final String id;
  final String todoName;
  final bool isComplete;

  Todo({required this.id, required this.todoName, required this.isComplete});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'] ?? '',
      todoName: json['todoName'] ?? '',
      isComplete: json['isComplete'] ?? false,
    );
  }
}

class GetDataTodos extends StatelessWidget {
  final Future<List<Todo>> Todos = fetchTodos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos from API'),
      ),
      body: Center(
        child: FutureBuilder<List<Todo>>(
          future: Todos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Open detailed information in a new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(todo: snapshot.data![index]),
                        ),
                      );
                    },
                    child: CardWithShadow(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${snapshot.data![index].id}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.5, // Jarak antar baris
                              ),
                            ),
                            Text(
                              'Name: ${snapshot.data![index].todoName}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                height: 1.5, // Jarak antar baris
                              ),
                            ),
                            Text(
                              'Is Complete: ${snapshot.data![index].isComplete}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                                height: 1.5, // Jarak antar baris
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Todo todo;

  const DetailPage({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ID: ${todo.id}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 1.5, // Jarak antar baris
              ),
            ),
            Text(
              'Name: ${todo.todoName}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 23,
                height: 1.5, // Jarak antar baris
              ),
            ),
            Text(
              'Is Complete: ${todo.isComplete}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                height: 1.5, // Jarak antar baris
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWithShadow extends StatelessWidget {
  final Widget child;

  CardWithShadow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blue,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
