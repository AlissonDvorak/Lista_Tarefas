import 'package:todo_list/app/core/database/modules/todo_list_modules.dart';
import 'package:todo_list/app/modules/auth/login/login_controller.dart';
import 'package:todo_list/app/modules/auth/register/register_page.dart';
import 'package:todo_list/app/modules/auth/register/register_controler.dart';
import 'package:provider/provider.dart';

import 'login/login_page.dart';

class AuthModule extends TodoListModule {
  AuthModule()
      : super(
          bindings: [
            ChangeNotifierProvider(
              create: (context) => LoginController(userService: context.read()),
            ),
            ChangeNotifierProvider(
                create: (context) =>
                    RegisterController(userService: context.read()))
          ],
          routers: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage()
          },
        );
}
