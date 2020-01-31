import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/models/city_event.dart';
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
              Text(
                  'In ${citySeasonToString(event.season)} of year ${event.yearHappened}'),
              if (event.messages.isNotEmpty)
                Column(
                  children: event.messages
                      .map((m) => Text(
                            m,
                            style: Theme.of(context).textTheme.bodyText1,
                          ))
                      .toList(),
                ),
              if (event.messages.isEmpty)
                Text(
                  'Nothing happened',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
            ],
          ),
        );
      },
    );
  }
}
