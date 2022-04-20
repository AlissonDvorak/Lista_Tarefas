import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list/app/core/database/ui/messages.dart';
import 'package:todo_list/app/core/notifier/default_change_notifier.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener({
    required BuildContext context,
    required SucessVoidCallBack sucessCallBack,
    ErrorVoidCallBack? errorCallBack,
    EverVoidCallBack? everCallBack,
  }) {
    changeNotifier.addListener(
      () {
        if (everCallBack != null) {
          everCallBack(changeNotifier, this);
        }
        if (changeNotifier.loading) {
          Loader.show(context);
        } else {
          Loader.hide();
        }
        if (changeNotifier.hasError) {
          if (errorCallBack != null) {
            errorCallBack(changeNotifier, this);
          }

          Messages.of(context)
              .showError(changeNotifier.error ?? 'Erro interno');
        } else if (changeNotifier.isSucess) {
          sucessCallBack(changeNotifier, this);
        }
      },
    );
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SucessVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef ErrorVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef EverVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);
