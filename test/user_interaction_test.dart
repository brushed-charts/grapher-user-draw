import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/user_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

void main() {
  test('Test anchor creation on user Tap', () {
    final tapPos = VirtualCoord.zero();
    final userInteraction = UserInteraction();
    userInteraction.onTap(tapPos);
    expect(userInteraction.shouldCreateAnchor, isTrue);
    expect(userInteraction.lastCoord, equals(tapPos));
    expect(userInteraction.lastAnchor, isNotNull);
  });
}
