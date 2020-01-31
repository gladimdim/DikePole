abstract class RandomEvent {
  RANDOM_EVENT_TYPE type;
  bool canMakeChoice;

  Map requiredParams;
}

enum RANDOM_EVENT_TYPE { TATAR_RAID, SICH_RAID }