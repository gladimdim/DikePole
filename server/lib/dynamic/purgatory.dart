import 'package:server/constants.dart';
import 'package:server/dynamic/filesystem.dart';

Future<List<String>> generatePurgatoryList() async {
  var files = await getEntriesInDirOfType("$DIR_ROOT/$PATH_PURGATORY");
  return files;
}
