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

enum RESOURCE_TYPES {
  MONEY,
  WOOD,
  FOOD,
  STONE,
  SULFUR,
  IRON,
  FUR,
  FISH,
  FIREARM,
  HORSE,
  IRON_ORE
}

String resourceTypesToString(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD:
      return 'Food';
    case RESOURCE_TYPES.MONEY:
      return 'Money';
    case RESOURCE_TYPES.WOOD:
      return 'Wood';
    case RESOURCE_TYPES.STONE:
      return 'Stone';
    case RESOURCE_TYPES.SULFUR:
      return 'Sulfur';
    case RESOURCE_TYPES.IRON:
      return 'Iron';
    case RESOURCE_TYPES.FUR:
      return 'Fur';
    case RESOURCE_TYPES.FIREARM:
      return 'Firearm';
    case RESOURCE_TYPES.HORSE:
      return 'Horse';
    case RESOURCE_TYPES.IRON_ORE:
      return 'Ore';
    case RESOURCE_TYPES.FISH:
      return 'Fish';
    default:
      return 'PLACEHOLDER';
  }
}

String resourceTypesToImagePath(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.MONEY:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.WOOD:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.STONE:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.SULFUR:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.IRON:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.FUR:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.FIREARM:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.HORSE:
      return 'images/city_building/resources/stone.png';
    case RESOURCE_TYPES.IRON_ORE:
      return 'images/city_building/resources/stone.png';
    default:
      return 'images/city_building/resources/stone.png';
  }
}
