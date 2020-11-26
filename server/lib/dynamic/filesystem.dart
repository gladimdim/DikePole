import 'dart:io';

Future<List> getEntriesInDirOfType<T>(String dir) async {
  var directory = Directory(dir);
  var result = [];
  await for (FileSystemEntity f in directory.list()) {
    if (f is T) {
      var folderName = f.path.split(dir + getPathDelimiter())[1];
      result.add(folderName);
    }
  }

  return result;
}

String getPathDelimiter() {
  return Platform.isLinux ? "/" : "\\";
}

Future<String> readFileContents(String path) async {
  var file = File(path);
  return await file.readAsString();
}
