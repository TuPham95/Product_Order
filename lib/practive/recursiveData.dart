import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecursiveDataLayout(),
    );
  }
}

class RecursiveDataLayout extends StatelessWidget {
  final String jsonData = '''
{
	"id":"Root Node",
	"data":[
				{
					"id":"level 1",
					"data": [
								{
									"id":"Level 1.1",
									"data":[]
								},
								{
									"id":"Level 1.2",
									"data":[]
								}
								
							]
				},
				
				{
					"id":"level 2",
					"data": [
								{
									"id":"Level 2.1",
									"data":[]
								},
								{
									"id":"Level 2.2",
									"data":[]
								}
								
							]
				}
			]
}
''';
  void printNote(Map<String, dynamic> node){
    // ky thuat de quy
    print(node['id']);
    for(var child in node['data']){
      printNote(child); // goi de quy
    }

  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = jsonDecode(jsonData);
    printNote(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Data From Api with multiple levels'),
      ),
      body: Center(
        child: const Text('View Data'),
      ),
    );
  }
}
