class Citizen {
  var assignedTo;
  final String name = 'Cossack';

  void free() {
    assignedTo = null;
  }

  bool occupied() {
    return assignedTo != null;
  }
}