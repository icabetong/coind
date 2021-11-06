import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 64,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(Translations.of(context)!.error_generic,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20.0)),
                  Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                          Translations.of(context)!.error_generic_summary,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white54)))
                ],
              ))
        ],
      ),
    );
  }
}
