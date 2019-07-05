import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restapi_app/Post.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Api Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              future: fetchPost(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      buildTextWidget(snapshot.data.userId.toString()),
                      buildTextWidget(snapshot.data.id.toString()),
                      buildTextWidget(snapshot.data.title.toString()),
                      buildTextWidget(snapshot.data.body.toString()),
                    ],
                  );
                } else if(snapshot.hasError) {
                  return Text(snapshot.error);
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextWidget(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value),
    );
  }

  Future<Post> fetchPost() async {
    var url = 'https://jsonplaceholder.typicode.com/posts/1';
    final response = await http.get(url);

    if(response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
