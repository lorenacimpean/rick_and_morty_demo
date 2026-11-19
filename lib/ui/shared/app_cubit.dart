import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

// Base for every view model: close() cancels what listenTo started and
// closes the subjects passed to the constructor.
abstract class AppCubit<S> extends Cubit<S> {
  final _subscriptions = CompositeSubscription();
  final List<Subject<Object?>> _subjects;

  // Callers pass `subjects:`; Dart drops the underscore for private named params.
  AppCubit(super.initialState, {this._subjects = const []});

  // Starts listening and loading. Screens call it once, from initState.
  void init();

  void listenTo<T>(
    Stream<T> stream,
    void Function(T data) onData, {
    void Function(Object error)? onError,
  }) => _subscriptions.add(stream.listen(onData, onError: onError));

  @override
  Future<void> close() async {
    await _subscriptions.dispose();
    await Future.wait([for (final subject in _subjects) subject.close()]);
    return super.close();
  }
}
