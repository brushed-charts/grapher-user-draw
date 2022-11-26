import 'package:grapher/kernel/object.dart';

class RefreshService {
  static GraphObject? _refreshableObject;
  RefreshService(GraphObject refreshableObject) {
    if (_refreshableObject == null) {
      RefreshService._refreshableObject = refreshableObject;
    }
  }

  static void refresh() => _refreshableObject!.setState(_refreshableObject!);
}
