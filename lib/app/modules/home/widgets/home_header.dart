import 'package:flutter/material.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/database/ui/theme_extensions.dart';
import 'package:provider/provider.dart';

import '../../../core/database/ui/config_ui.dart.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeChanger? themeChanger;
    themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Selector<AuthProvider, String>(
          selector: (context, authProvider) =>
              authProvider.user?.displayName ?? 'Favor alterar o nome  ',
          builder: (_, value, __) {
            return Text('E ai, $value!',
                style: context.textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        themeChanger?.isDark() ? Colors.white : Colors.black));
          }),
    );
  }
}
