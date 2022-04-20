import 'package:flutter/material.dart';
import 'package:todo_list/app/core/database/ui/theme_extensions.dart';
import 'package:todo_list/app/core/database/widget/todo_list_field.dart';
import 'package:todo_list/app/core/database/widget/todo_list_logo.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/modules/auth/register/register_controler.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegistePageState();
}

class _RegistePageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var defaultListener = DefaultListenerNotifier(
        changeNotifier: context.read<RegisterController>());
    defaultListener.listener(
      context: context,
      sucessCallBack: (notifier, listenerinstance) {
        listenerinstance.dispose();
      },
      // opcional::
      // errorCallBack: (notifier, listenerinstance) {
      //   print('Deu ruim');
      //  }
    );
    //  context.read<RegisterController>().addListener(() {
    //   final controller = context.read<RegisterController>();
    //   var succes = controller.sucess;
    //   var error = controller.error;
    //   if (succes) {
    //     Navigator.of(context).pop();
    //   } else if (error != null && error.isNotEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(error),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Tarefas',
              style: TextStyle(fontSize: 10, color: context.primaryColor),
            ),
            Text(
              'cadastro',
              style: TextStyle(fontSize: 15, color: context.primaryColor),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          // ignore: sized_box_for_whitespace
          Container(
            height: MediaQuery.of(context).size.width * .5,
            child: const FittedBox(
              child: TodoListLogo(),
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TodoListField(
                      label: 'Email',
                      controller: _emailEC,
                      valitator: Validatorless.multiple([
                        Validatorless.required('email obrigatorio'),
                        Validatorless.email('email invalido'),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TodoListField(
                      label: 'Senha',
                      controller: _passwordEC,
                      obscureText: true,
                      valitator: Validatorless.multiple([
                        Validatorless.required('Senha obrigatoria'),
                        Validatorless.min(
                            6, 'Senha deve ter no minimo 6 caracteres'),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TodoListField(
                      label: 'Confirma Senha',
                      controller: _confirmPasswordEC,
                      valitator: Validatorless.multiple([
                        Validatorless.required('Confirma Senha obrigatoria'),
                        Validatorless.compare(
                            _passwordEC, 'As senhas nao correspondem')
                      ]),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final formValid =
                              _formkey.currentState?.validate() ?? false;
                          final email = _emailEC.text;
                          final password = _passwordEC.text;
                          if (formValid) {
                            context
                                .read<RegisterController>()
                                .registerUser(email, password);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Registrar'),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
