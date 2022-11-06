import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/factory/factory.dart';
import 'package:grapher/filter/accumulate-sorted.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/geometry/candlestick.dart';
import 'package:grapher/geometry/line.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/pack/example/json-oanda.dart';
import 'package:grapher/pack/pack.dart';
import 'package:grapher/pack/unpack-view.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/pointer/widget.dart';
import 'package:grapher/splitter/horizontal.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/view/window.dart';

import 'package:flutter/material.dart';

main(List<String> args) async {
  runApp(App());
}

Stream<Map> streamer(Map json) async* {
  yield json;
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final graph = createGraph();
    return MaterialApp(
      theme: getThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GraphPointer(kernel: graph),
            )
          ],
        ),
      ),
    );
  }

  ThemeData getThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
    );
  }

  GraphKernel createGraph() {
    final oandaJSON = getMockOandaJSON();

    return GraphKernel(
        child: HorizontalSplitter(children: [
      StackLayout(children: [
        DataInjector(
            stream: streamer(oandaJSON),
            child: Extract(
                options: "data.oanda",
                child: Explode(
                    child: ToCandle2D(
                        xLabel: "datetime",
                        yLabel: "price",
                        child: Tag(
                            name: 'oanda',
                            child: PipeIn(
                                eventType: IncomingData,
                                name: 'pipe_main')))))),
        PipeOut(
            name: 'pipe_main',
            child: Pack(
                child: SortAccumulation(
                    child: Window(
                        child: StackLayout(children: [
              UnpackFromViewEvent(
                  tagName: 'oanda',
                  child: DrawUnitFactory(
                      template: DrawUnit.template(child: Candlestick()))),
            ])))))
      ]),
    ]));
  }
}