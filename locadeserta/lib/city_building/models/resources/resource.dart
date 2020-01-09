class Resource {
  int quantity = 1;
  int name;
  RESOURCE_TYPES type;

  Resource(this.type);

  static Resource createWood() {
    return Resource(RESOURCE_TYPES.WOOD);
  }

  static Resource createFood() {
    return Resource(RESOURCE_TYPES.FOOD);
  }

  static Resource createStone() {
    return Resource(RESOURCE_TYPES.STONE);
  }

  static Resource createSulfur() {
    return Resource(RESOURCE_TYPES.SULFUR);
  }

  static Resource createIron() {
    return Resource(RESOURCE_TYPES.IRON);
  }

  static Resource createFur() {
    return Resource(RESOURCE_TYPES.FUR);
  }

  static Resource createFish() {
    return Resource(RESOURCE_TYPES.FISH);
  }

  static Resource createHose() {
    return Resource(RESOURCE_TYPES.HORSE);
  }
}

enum RESOURCE_TYPES { MONEY, WOOD, FOOD, STONE, SULFUR, IRON, FUR, FISH, FIREARM, HORSE }

String resourceTypesToString(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD: return 'Food';
    case RESOURCE_TYPES.MONEY: return 'Money';
    default: return 'PLACEHOLDER';
  }
}