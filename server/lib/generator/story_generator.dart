import 'package:server/generator/backend.dart';

void run() async {
  var stories = await fetchStories();
  print(stories.length);
}
