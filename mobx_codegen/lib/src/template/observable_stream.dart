import 'package:mobx_codegen/src/template/annotations_generator_mixin.dart';
import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/store.dart';

class ObservableStreamTemplate with AnnotationsGenerator {
  ObservableStreamTemplate({
    required this.method,
    required this.storeTemplate,
    required bool hasProtected,
    required bool hasVisibleForOverriding,
    required bool hasVisibleForTesting,
  }) {
    this.hasProtected = hasProtected;
    this.hasVisibleForOverriding = hasVisibleForOverriding;
    this.hasVisibleForTesting = hasVisibleForTesting;
  }

  final MethodOverrideTemplate method;
  final StoreTemplate storeTemplate;

  @override
  String toString() => """
  $annotations
  ObservableStream${method.returnTypeArgs} ${method.name}${method.typeParams}(${method.params}) {
    final _\$stream = super.${method.name}${method.typeArgs}(${method.args});
    return ObservableStream${method.returnTypeArgs}(_\$stream, context: ${storeTemplate.contextName});
  }""";
}
