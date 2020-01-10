class Citizen {
  var assignedTo;

  void free() {
    assignedTo = null;
  }

  bool occupied() {
    return assignedTo != null;
  }
}