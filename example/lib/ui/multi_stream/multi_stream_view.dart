import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'multi_stream_view_model.dart';

class StreamCounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MultiStreamViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              body: Column(children: [
                Text("Slow Stream: ${model.slowNumber}"),
                Text("Fast Stream: ${model.fastNumber}"),
                FlatButton(
                  child: Text("Grow Number"),
                  onPressed: () => model.growBigger(10),
                )
              ]),
            ),
        viewModelBuilder: () => MultiStreamViewModel());
  }
}
