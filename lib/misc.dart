import 'dart:math';

class Misc {
  static int generateUniqueID() {
    final epoch = DateTime.now().microsecondsSinceEpoch;
    final randomNumber = Random().nextInt(1000);
    return int.parse('$epoch$randomNumber');
  }
}
