import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_architecture/app/locator.dart';
import 'package:new_architecture/ui/hook_viewmodel_widget/hook_viewmodel_widget_example.dart';
import 'package:new_architecture/ui/multiple_streams_example/multiple_streams_example_view.dart';
import 'package:new_architecture/ui/stream_view/stream_counter_view.dart';

void main() {
  configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: Get.key,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamCounterView(),
    );
  }
}
