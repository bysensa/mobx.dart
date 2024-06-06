import 'package:mobx_codegen/src/template/provide.dart';
import 'package:mobx_codegen/src/template/rows.dart';

class DidChangeDependenciesTemplate {
  final Rows<ProvideTemplate> provides = Rows();

  void add(ProvideTemplate template) => provides.add(template);

  @override
  String toString() {
    return '''
    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      ${provides.templates.fold(StringBuffer(), (str, el) {
      return str..writeln(el.buildWatchAssignment());
    })}
    }
    ''';
  }
}
