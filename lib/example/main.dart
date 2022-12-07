import 'package:grapher/cell/event.dart';
import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/geometry/candlestick.dart';
import 'package:grapher/factory/factory.dart';
import 'package:grapher/filter/accumulate-sorted.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/pack/pack.dart';
import 'package:grapher/pack/unpack-view.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/reference/main.dart';
import 'package:grapher/reference/memory_repository.dart';
import 'package:grapher/reference/reader.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/utils/merge.dart';
import 'package:grapher/view/window.dart';

import 'package:flutter/material.dart';
import 'package:grapher/pointer/widget.dart';
import 'package:grapher_user_draw/bypass_pointer_event.dart';
import 'package:grapher_user_draw/entrypoint_viewable.dart';
import 'draw_tool_tester.dart';
import 'fake_tool_propagator.dart';

import 'json.dart';

final fakeToolPropagator = FakeToolPropagator();
final referenceRepository = ReferenceRepositoryInMemory();
var isCreatingMode = true;

main(List<String> args) async {
  runApp(const App());
}

Stream<Map> streamer(Map json) async* {
  yield json;
}

class App extends StatelessWidget {
  const App({super.key});
  void onCreation() {
    if (isCreatingMode) {
      fakeToolPropagator.propagateDrawTool(null);
    } else {
      fakeToolPropagator.propagateDrawTool(DrawToolTester());
    }
    isCreatingMode = !isCreatingMode;
  }

  void onBypass() {
    final bypass =
        referenceRepository.access<PointerEventBypassChild>('pointer_bypass')!;
    if (bypass.isEnabled) {
      bypass.disable();
    } else {
      bypass.enable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final graph = createGraph();
    fakeToolPropagator.propagateDrawTool(DrawToolTester());
    return MaterialApp(
      theme: getThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.edit),
                  color: Colors.deepPurpleAccent,
                  onPressed: onCreation,
                ),
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.switch_access_shortcut),
                  color: Colors.deepPurpleAccent,
                  onPressed: onBypass,
                ),
              ],
            ),
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
    final json = getMockJSON();
    return GraphKernel(
        child: StackLayout(children: [
      DataInjector(
          stream: streamer(json),
          child: Extract(
              options: "data.getCandles",
              child: Explode(
                  child: ToCandle2D(
                      xLabel: "date",
                      yLabel: "mid",
                      child: Tag(
                          name: 'oanda',
                          child: PipeIn(
                              eventType: IncomingData, name: 'pipe_main')))))),
      PipeOut(
          name: 'pipe_main',
          child: Pack(
              child: SortAccumulation(
                  child: PointerEventBypassChild(
                      child: Reference(
                          name: "pointer_bypass",
                          repository: referenceRepository,
                          child: PointerEventBypassChild(
                              child: Window(
                                  child: StackLayout(children: [
                            UnpackFromViewEvent(
                                tagName: 'oanda',
                                child: DrawUnitFactory(
                                    template: DrawUnit.template(
                                        child: Candlestick(
                                            child: MergeBranches(
                                                child: PipeIn(
                                                    name: 'pipe_cell',
                                                    eventType: CellEvent)))))),
                            fakeToolPropagator.chainUp(
                                child: GrapherUserDraw(
                                    pointerBypass: ReferenceReader(
                                        refName: "pointer_bypass",
                                        repository: referenceRepository)))
                          ])))))))),
    ]));
  }
}
