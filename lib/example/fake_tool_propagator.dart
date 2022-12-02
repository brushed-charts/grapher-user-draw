import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_event.dart';
import 'package:grapher_user_draw/example/draw_tool_tester.dart';

class FakeToolPropagator extends Viewable with SinglePropagator {
  bool alreadySentToolEvent = false;
  FakeToolPropagator({required GraphObject child}) {
    this.child = child;
  }

  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    propagate(viewEvent);
    if (!alreadySentToolEvent) propagate(DrawToolEvent(DrawToolTester()));
    alreadySentToolEvent = true;
  }
}
