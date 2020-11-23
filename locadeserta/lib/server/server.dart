import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:http/http.dart' as http;

var url = "http://localhost:9093";

Future<String> uploadStoryToServer(Story story) async {
  var result = await http.post("$url/post_story", body: story.toStateJson());
  return result.body;
}
