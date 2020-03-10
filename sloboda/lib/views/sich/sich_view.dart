import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/sich_stats_view.dart';

class SichScreen extends StatefulWidget {
  static String routeName = '/sich';
  final Sloboda city;

  SichScreen({this.city});

  @override
  _SichScreenState createState() => _SichScreenState();
}

class _SichScreenState extends State<SichScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SichStatsView(
          city: widget.city,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: TitleText(
          SlobodaLocalizations.sichName,
        ),
      ),
    );
  }
}

class SichScreenArguments {
  final Sloboda city;

  SichScreenArguments({this.city});
}

class ExtractSichScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final SichScreenArguments args = ModalRoute.of(context).settings.arguments;

    return SichScreen(
      city: args.city,
    );
  }
}
