import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

class AboutRoute extends StatelessWidget {
  const AboutRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.navigation_about),
      ),
      body: SettingsList(
        backgroundColor: Theme.of(context).backgroundColor,
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(title: Translations.of(context)!.about_framework),
              SettingsTile(
                title: Translations.of(context)!.about_data_provider,
                subtitle: Translations.of(context)!.about_data_provider_summary,
              )
            ],
          )
        ],
      ),
    );
  }
}
