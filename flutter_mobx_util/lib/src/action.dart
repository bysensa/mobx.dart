import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart' hide Action;

abstract class MobxAction<T extends Intent> = Action<T> with MobxActionMixin<T>;
abstract class MobxContextAction<T extends Intent> = ContextAction<T>
    with MobxActionMixin<T>;

/// Mixin for [Action] that supports MobX reactivity
///
/// Used for [MobxAction] and [MobxContextAction] classes to support reactivity for [isActionEnabled] and [isConsumesKey] fields
/// to perform components rebuilds when these fields are changed in reaction of MobX store changes
mixin MobxActionMixin<T extends Intent> on Action<T> {
  /// Number of listeners for this action
  ///
  /// Value is incremented when listener is added and decremented when listener is removed
  int _listenersCount = 0;

  @override
  bool isEnabled(T intent, [BuildContext? context]) => isActionEnabled;

  @override
  bool consumesKey(T intent) => isConsumesKey;

  /// Adds listener to this action
  ///
  /// Method overrided to support MobX reactions setup for isActionEnabled and isConsumesKey
  /// When first listener is added, reactions is set up
  @override
  void addActionListener(ActionListenerCallback listener) {
    super.addActionListener(listener);
    _listenersCount++;
    _maybeSetUpIsEnabledReaction();
    _maybeSetUpConsumesKeyReaction();
  }

  /// Removes listener from this action
  ///
  /// Method overrided to support MobX reactions teardown for isActionEnabled and isConsumesKey
  /// When last listener is removed, reaction is disposed
  @override
  void removeActionListener(ActionListenerCallback listener) {
    super.removeActionListener(listener);
    _listenersCount--;
    _maybeTearDownIsEnabledReaction();
    _maybeTearDownConsumesKeyReaction();
  }

  //<editor-fold defaultstate="collapsed" desc="IsActionEnabled implementation">
  final _isEnabledAtom = Atom();

  /// Disposer for isActionEnabled reaction
  ///
  /// Instance is created when first listener is added
  /// After last listener is removed, reaction is disposed
  Dispose? _isEnabledEffectDispose;

  /// Whether this action is enabled or not
  ///
  /// Provide value from [isActionEnabledPredicate] evaluation result
  @override
  bool get isActionEnabled {
    _isEnabledAtom.reportRead();
    return _isActionEnabled;
  }

  /// Internal variable for [isActionEnabled] value
  ///
  /// Value is updated using reaction when [isActionEnabledPredicate] is evaluated and action has listeners
  bool _isActionEnabled = true;

  /// Predicate for [isActionEnabled] value
  ///
  /// Default value is true and can be extended by subclass
  @protected
  bool isActionEnabledPredicate() => true;

  /// Sets up reaction for [isActionEnabled] value
  ///
  /// Reaction is set up when first listener is added
  void _maybeSetUpIsEnabledReaction() {
    if (_listenersCount > 0 && _isEnabledEffectDispose == null) {
      _isEnabledEffectDispose = reaction(
        (_) => isActionEnabledPredicate(),
        (value) {
          _isEnabledAtom.reportWrite(
            value,
            _isActionEnabled,
            () {
              _isActionEnabled = value;
            },
          );
          notifyActionListeners();
        },
        fireImmediately: true,
      ).call;
    }
  }

  /// Tears down reaction for [isActionEnabled] value
  ///
  /// Reaction is disposed when last listener is removed
  void _maybeTearDownIsEnabledReaction() {
    if (_listenersCount == 0 && _isEnabledEffectDispose != null) {
      _isEnabledEffectDispose?.call();
      _isEnabledEffectDispose = null;
    }
  }
  //</editor-fold>

  //<editor-fold defaultstate="collapsed" desc="isConsumesKey implementation">
  final Atom _isConsumesKeyAtom = Atom();

  /// Disposer for isConsumesKey reaction
  ///
  /// Instance is created when first listener is added
  /// After last listener is removed, reaction is disposed
  Dispose? _isConsumesKeyEffectDispose;

  /// Whether this action consumes key or not
  ///
  /// Provide value from [isConsumesKeyPredicate] evaluation result
  bool _isConsumesKey = true;

  /// Internal variable for [isConsumesKey] value
  bool get isConsumesKey {
    _isConsumesKeyAtom.reportRead();
    return _isConsumesKey;
  }

  /// Predicate for [isConsumesKey] value
  ///
  /// Default value is true and can be extended by subclass
  bool isConsumesKeyPredicate() => true;

  /// Sets up reaction for [isConsumesKey] value
  ///
  /// Reaction is set up when first listener is added
  void _maybeSetUpConsumesKeyReaction() {
    if (_listenersCount > 0 && _isConsumesKeyEffectDispose == null) {
      _isConsumesKeyEffectDispose = reaction(
        (_) => isConsumesKeyPredicate(),
        (value) {
          _isConsumesKeyAtom.reportWrite(
            value,
            _isConsumesKey,
            () {
              _isConsumesKey = value;
            },
          );
          notifyActionListeners();
        },
        fireImmediately: true,
      ).call;
    }
  }

  /// Tears down reaction for [isConsumesKey] value
  ///
  /// Reaction is disposed when last listener is removed
  void _maybeTearDownConsumesKeyReaction() {
    if (_listenersCount == 0 && _isConsumesKeyEffectDispose != null) {
      _isConsumesKeyEffectDispose?.call();
      _isConsumesKeyEffectDispose = null;
    }
  }
}
