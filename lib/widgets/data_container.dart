import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationWithChip extends StatelessWidget {
  const InformationWithChip(
      {Key? key, required this.header, required this.data})
      : super(key: key);

  final String header;
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(header,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 0,
                children: data.map((e) {
                  String text = e;
                  bool isUrl = text.startsWith("http");
                  if (isUrl) {
                    int lastIndex =
                        e.endsWith('/') ? e.lastIndexOf('/') : e.length;
                    text = e.substring(e.indexOf('//') + 2, lastIndex);
                  }

                  return !isUrl
                      ? Chip(
                          label: Text(text),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        )
                      : ActionChip(
                          label: Text(text),
                          onPressed: () async {
                            await canLaunch(e)
                                ? launch(e)
                                : ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(Translations.of(context)!
                                        .error_generic),
                                  ));
                          });
                }).toList(),
              ),
            )
          ],
        ));
  }
}

class TwoLineDataCard extends StatelessWidget {
  const TwoLineDataCard(
      {Key? key,
      required this.header,
      required this.mainData,
      required this.supportingData})
      : super(key: key);

  final String header;
  final String mainData;
  final String supportingData;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                header.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(mainData,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0)),
              ),
              Text(supportingData, style: const TextStyle(fontSize: 16.0))
            ],
          ),
        ));
  }
}

class ThreeDataContainer extends StatelessWidget {
  const ThreeDataContainer(
      {Key? key,
      required this.header,
      required this.mainData,
      required this.siblingData,
      required this.supportingData})
      : super(key: key);

  final String header;
  final String mainData;
  final String siblingData;
  final String supportingData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(header.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              )),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mainData,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )),
                Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: Text(siblingData,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 16.0)))
              ],
            ),
            Text(supportingData, style: const TextStyle(color: Colors.white))
          ])
        ],
      ),
    );
  }
}

class TwoLineDataContainer extends StatelessWidget {
  const TwoLineDataContainer(
      {Key? key,
      required this.header,
      required this.supportingData,
      required this.mainData})
      : super(key: key);

  final String header;
  final String supportingData;
  final String mainData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(header.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              )),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(mainData,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                )),
            Text(supportingData, style: Theme.of(context).textTheme.overline)
          ])
        ],
      ),
    );
  }
}

class OneLineDataContainer extends StatelessWidget {
  const OneLineDataContainer(
      {Key? key, required this.header, required this.data})
      : super(key: key);

  final String header;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(header.toUpperCase(),
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0)),
            Text(data,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ))
          ],
        ));
  }
}
