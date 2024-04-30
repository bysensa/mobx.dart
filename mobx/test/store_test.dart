import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

class TestStore with Store {}

final customContext = ReactiveContext();

class CustomStore with Store {
  @override
  ReactiveContext get rcontext => customContext;
}

void main() {
  group('Store', () {
    test('can get context', () {
      final store = TestStore();
      expect(store.rcontext, mainContext);
    });

    test('Store with custom context', () {
      final store = CustomStore();
      expect(store.rcontext, customContext);
    });
  });
}
