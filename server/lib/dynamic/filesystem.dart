import 'dart:io';

Future<List> getEntriesInDirOfType<T>(String dir) async {
  var directory = Directory(dir);
  var result = [];
  await for (FileSystemEntity f in directory.list()) {
    var delimiter = Platform.isLinux ? "/" : "\\";
    if (f is T) {
      var folderName = f.path.split(dir + delimiter)[1];
      result.add(folderName);
    }
  }

  return result;
}
