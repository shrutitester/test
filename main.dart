import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dataModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ResponseModel>? responseModel;
  List<ResponseModel>? filteredList = [];

  Future<List<ResponseModel>>? getResponseFromApi() async {
    Uri url = Uri.https('jsonplaceholder.typicode.com', 'todos');
    var result = await http.get(url);
    var response = jsonDecode(result.body);
    List<ResponseModel> dataItemList = [];
    for (Map<String, dynamic> item in response ?? []) {
      dataItemList.add(ResponseModel.fromJson(item));
    }
    print("Parsed api response---> $dataItemList");

    return dataItemList;
  }

  @override
  void initState() {
    getResponseFromApi()?.then((value) {
      if (value.isNotEmpty) {
        // setState(() {
        responseModel = value;
        for (ResponseModel item in responseModel ?? []) {
          if (item.userId == 1) {
            setState(() {
              // List<ResponseModel>? filteredList = [];
              filteredList?.add(item);
            });
          }
        }
        // });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
          itemCount: filteredList?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("Title - ${filteredList?[index].title}" ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User Id - ${filteredList?[index].userId.toString()}"),
                  Text("Unique Id - ${filteredList?[index].id.toString()}"),
                ],
              ),
              onTap: () {
                int uniqueId = filteredList?[index].id ?? 0;
                print("unique id---> $uniqueId");

                List<ResponseModel> getList = [];

                for (ResponseModel item in responseModel ?? []) {
                  if (uniqueId == item.userId  ) {
                    getList.add(item);
                    filteredList = [];
                    setState(() {
                      filteredList = getList;
                    });
                  }
                }
              },
            );
          },
          separatorBuilder: (BuildContext context, int index){
            return const Divider();
          }
      ),
    );
  }
}
