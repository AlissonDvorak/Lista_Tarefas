import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/database/ui/config_ui.dart.dart';
import 'package:todo_list/app/core/database/ui/messages.dart';
import 'package:todo_list/app/core/database/ui/theme_extensions.dart';
import 'package:todo_list/app/services/user/user_service.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  ThemeChanger? themeChanger;

  final nameVN = ValueNotifier<String>('');

  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: context.primaryColor.withAlpha(70)),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: (context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Breezeicons-actions-22-im-user.svg/1200px-Breezeicons-actions-22-im-user.svg.png';
                  },
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      selector: (context, authProvider) {
                        return authProvider.user?.displayName ?? 'Sem usuario';
                      },
                      builder: (_, value, __) {
                        return Text(
                          value,
                          style: TextStyle(
                              color: themeChanger?.isDark()
                                  ? Colors.white
                                  : Colors.black),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(
                        'Alterar Nome',
                        style: TextStyle(
                            color: themeChanger?.isDark()
                                ? Colors.white
                                : Colors.black),
                      ),
                      content: TextField(
                        onChanged: (value) {
                          nameVN.value = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'cancelar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              final nameValue = nameVN.value;
                              if (nameValue.isEmpty) {
                                Messages.of(context)
                                    .showError('Nome Obrigatorio');
                              } else {
                                Loader.show(context);
                                await context
                                    .read<UserService>()
                                    .updateName(nameValue);
                                Loader.hide();
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Confirmar')),
                      ],
                    );
                  });
            },
            title: Text(
              'Alterar Nome',
              style: TextStyle(
                  color: themeChanger?.isDark() ? Colors.white : Colors.black),
            ),
          ),
          ListTile(
            title: Text(
              'Sair',
              style: TextStyle(
                  color: themeChanger?.isDark() ? Colors.white : Colors.black),
            ),
            onTap: () {
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
    );
  }
}
