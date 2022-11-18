import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/user_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

void main() {
  test('Test anchor creation on user Tap', () {
    final tapDatetime = DateTime(2022, 11, 19);
    const double tapY = 867;
    final tapPos = VirtualCoord(tapDatetime, tapY);
    final expectedAnchor = Anchor(x: tapDatetime, y: tapY);
    final userInteraction = UserInteraction();
    userInteraction.onTap(tapPos);
    expect(userInteraction.lastAnchor, equals(expectedAnchor));
  });
}
