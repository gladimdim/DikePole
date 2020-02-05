import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/soft_container.dart';

class EventsView extends StatelessWidget {
  final List<CityEvent> events;

  EventsView({this.events});


  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: events.length,
      separatorBuilder: (context, index) {
        return VDivider();
      },
      itemBuilder: (context, index) {
        final event = events[events.length - 1 - index];
        return SoftContainer(
          child: Column(
            children: <Widget>[
              TitleText(
                  '${SlobodaLocalizations.getForKey(citySeasonToString(event.season))} ${event.yearHappened}'),
              if (event.messages.isNotEmpty)
                Column(
                  children: event.messages
                      .map((m) => Text(
                            m,
                            style: Theme.of(context).textTheme.bodyText2,
                          ))
                      .toList(),
                ),
              if (event.messages.isEmpty)
                Text(
                  SlobodaLocalizations.nothingHappened,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
            ],
          ),
        );
      },
    );
  }
}
