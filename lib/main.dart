import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Future<String> getAdvice() async {
  final url = 'https://api.adviceslip.com/advice';
  var response = await http.get(url);
  String advice;
  if (response.statusCode == 200) {
    //request status ok

    var jsonResponse = convert.jsonDecode(response.body);
    advice = jsonResponse["slip"]["advice"];
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return advice;
}

class _MyAppState extends State<MyApp> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SmartRefresher(
          header: WaterDropHeader(),
          enablePullDown: true,
          onRefresh: () {
            setState(() {
              print('refreshing..');
            });
            _refreshController.refreshCompleted();
          },
          controller: _refreshController,
          child: FutureBuilder(
            future: getAdvice(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Text('Getting advice..'),
                );
              } else {
                return Center(
                  child: Text(snapshot.data),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
