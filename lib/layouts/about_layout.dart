import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About').tr(),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                 Text(
                  'About This App'.tr(),
                  style:const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Gap(16),
                const Text(
                  'This app is designed to help you manage your notes effectively.You can add, edit, and delete notes, and categorize them for better organization.',
                ).tr(),
                const Gap(16),
                  Text(
                  'Version 1.0.0'.tr(),
                  style:const  TextStyle(fontStyle: FontStyle.italic),
                ),
                const  Gap(16),
                  Text(
                  'Developed by Your Sultan Khaled'.tr(),
                  style:const TextStyle(fontStyle: FontStyle.italic),
                ),
                const Gap(16),
                const Text(
                  'For more information, visit our website or contact support.',
                ).tr(),
                //contact info
                Gap(8),
                const Text(
                  'Email: skmain850gmail.com',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                 

                const Gap(16),
                  Text(
                  'Thank you for using our app!'.tr(),
                  style:const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
