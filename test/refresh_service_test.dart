import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher_user_draw/refresh_service.dart';
import 'package:mocktail/mocktail.dart';

class MockGraphObject extends Mock implements GraphObject {}

void main() {
  test(
      'Assert RefreshService get public the setState function from the GraphObject',
      () {
    registerFallbackValue(MockGraphObject());
    final mockGraphObject = MockGraphObject();
    RefreshService(mockGraphObject);
    RefreshService.refresh();
    verify(() => mockGraphObject.setState(any())).called(1);
  });
}
