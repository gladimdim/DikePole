class Catalog {
  List<SavedGame> savedGames;

  SavedGame getSavedGameByName(String name) {
    return savedGames.firstWhere((game) => game.name == name);
  }
}

class SavedGame {
  final String name;
  final String filepath;
  SavedGame({this.name, this.filepath});
}