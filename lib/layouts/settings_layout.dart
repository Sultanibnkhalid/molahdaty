import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings').tr(),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale('en'));
                SystemNavigator.pop();
              },
              child: Text('English'.tr()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                context.setLocale(Locale('ar'));
                SystemNavigator.pop();
              },
              child: const Text('Arabic').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
