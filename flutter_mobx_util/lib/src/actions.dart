import 'package:flutter/widgets.dart';

import 'action.dart';

/// A widget that provides actions for underlying widgets.
///
/// Provided actions are defined by [actions] parameter
/// Under the hood actions iterable is converted to map.
/// And action in map depending on readonly property is wrapped with Action.overridable.
class ActionsProvider extends StatelessWidget {
  const ActionsProvider({
    super.key,
    required this.actions,
    required this.child,
    this.dispatcher,
    this.overrides = const {},
  });

  /// Dispatcher for actions dispatching
  final ActionDispatcher? dispatcher;

  /// Actions iterable
  final Iterable<MobxActionMixin> actions;

  /// Overrides for actions
  ///
  /// Can be used in situations when you want to override action
  /// for example when you want use another Intent type for action
  final Map<Type, MobxActionMixin> overrides;

  /// Child widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Convert iterable to map of actions
    final actionsMap = {
      for (final action in actions)
        action.intentType: Action.overridable(
          defaultAction: action,
          context: context,
        ),
      ...overrides,
    };

    return Actions(
      dispatcher: dispatcher,
      actions: actionsMap,
      child: child,
    );
  }
}
