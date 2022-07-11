import 'package:carex_flutter/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }
}
