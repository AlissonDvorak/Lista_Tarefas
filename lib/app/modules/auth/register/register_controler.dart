import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/services/user/user_service.dart';
import 'package:todo_list/exception/auth_exception.dart';

class RegisterController extends DefaultChangeNotifier {
  final UserService _userService;

  RegisterController({required UserService userService})
      : _userService = userService;

  void registerUser(String email, String password) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      final user = await _userService.register(email, password);
      if (user != null) {
        sucess();
      } else {
        setError('Erro ao registrar usuario');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
