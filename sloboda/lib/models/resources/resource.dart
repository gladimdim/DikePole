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
    return Resource(RESOURCE_TYPES.NITER);
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
  NITER,
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
    case RESOURCE_TYPES.NITER:
      return 'Niter';
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

String resourceTypesToIconPath(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD:
      return 'images/resources/food_64.png';
    case RESOURCE_TYPES.MONEY:
      return 'images/resources/money_64.png';
    case RESOURCE_TYPES.WOOD:
      return 'images/resources/wood_64.png';
    case RESOURCE_TYPES.STONE:
      return 'images/resources/stone_64.png';
    case RESOURCE_TYPES.NITER:
      return 'images/resources/niter_64.png';
    case RESOURCE_TYPES.FUR:
      return 'images/resources/fur_64.png';
    case RESOURCE_TYPES.FIREARM:
      return 'images/resources/firearm_64.png';
    case RESOURCE_TYPES.HORSE:
      return 'images/resources/horse_64.png';
    case RESOURCE_TYPES.IRON_ORE:
      return 'images/resources/iron_ore_64.png';
    case RESOURCE_TYPES.FISH:
      return 'images/resources/fish_64.png';

  }
}

String resourceTypesToImagePath(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD:
      return 'images/resources/food.png';
    case RESOURCE_TYPES.MONEY:
      return 'images/resources/money.png';
    case RESOURCE_TYPES.WOOD:
      return 'images/resources/wood.png';
    case RESOURCE_TYPES.STONE:
      return 'images/resources/stone.png';
    case RESOURCE_TYPES.NITER:
      return 'images/resources/niter.png';
    case RESOURCE_TYPES.FUR:
      return 'images/resources/fur.png';
    case RESOURCE_TYPES.FIREARM:
      return 'images/resources/firearm.png';
    case RESOURCE_TYPES.HORSE:
      return 'images/resources/horse.png';
    case RESOURCE_TYPES.IRON_ORE:
      return 'images/resources/iron_ore.png';
    case RESOURCE_TYPES.FISH:
      return 'images/resources/fish.png';

  }
}
